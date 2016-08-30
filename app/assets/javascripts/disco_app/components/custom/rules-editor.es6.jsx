/**
 * Defines a generic RulesEditor class. This class can't be used directly, but
 * should be inherited, with the inheriting class defining a list of column
 * types and corresponding relations and condition data types, like so:
 *
 *    class MyRulesEditor extends RulesEditor {};
 *    MyRulesEditor.defaultProps = {
 *      columns: {
 *        title: {
 *        label: 'Product title',
 *        column: 'title',
 *        relations: RulesEditor.buildRelationsObj([RulesEditor.EQUALS_STRING])
 *      }
 *    }
 */
class RulesEditor extends React.Component {

  /**
   * Initialise the Rules Editor, and set the initial state.
   * @param props
   */
  constructor(props) {
    super(props);
    this.state = {
      rules: props.rules.map((rule, i) => {
        return Object.assign({}, rule, {
          column: Object.keys(this.props.columns).filter((columnKey) => {
            return this.props.columns[columnKey].column == rule.column;
          })[0]
        });
      })
    }
  }

  componentDidMount() {
    if(this.state.rules.length === 0 && this.props.blankOk === false) {
      this.onAddRule();
    }
  }

  /**
   * Add a new rule, with an immutable state change.
   */
  onAddRule() {
    const column = Object.keys(this.props.columns)[0];
    const relation = this.getNextRelation(column);
    const condition = this.getNextCondition(column, relation);

    this.setState({
      rules: this.state.rules.concat([{
        column,
        relation,
        condition
      }])
    });
  }

  /**
   * Remove a rule, with an immutable state change.
   */
  onRemoveRule(index) {
    this.setState({
      rules: [
        ...this.state.rules.slice(0, index),
        ...this.state.rules.slice(index + 1)
      ]
    });
  }

  /**
   * Handle a change in a rule's column attribute.
   *
   * @param index
   * @param column
   */
  onRuleColumnChange(index, column) {
    const relation = this.getNextRelation(column, this.state.rules[index]);
    const condition = this.getNextCondition(column, relation, this.state.rules[index]);

    this.updateRule(index, {
      column,
      relation,
      condition
    })
  }

  /**
   * Handle a change in a rule's relation attribute.
   *
   * @param index
   * @param relation
   */
  onRuleRelationChange(index, relation) {
    const condition = this.getNextCondition(this.state.rules[index].column, relation, this.state.rules[index]);

    this.updateRule(index, {
      relation,
      condition
    });
  }

  /**
   * Handle a change in a rule's condition attribute.
   *
   * @param index
   * @param condition
   */
  onRuleConditionChange(index, condition) {
    this.updateRule(index, {
      condition
    });
  }

  /**
   * Handle a change in a rule's variables
   *
   * @param index
   * @param name
   * @param value
   */
  onRuleVariableChange(index, name, value) {
    this.updateRule(index, {
      [name]: value
    });
  }

  /**
   * Given the column we're changing to and the current rule, return the next
   * relation value.
   *
   * @param nextColumn
   * @param currentRule
   */
  getNextRelation(nextColumn, currentRule) {
    // If the new column provides for the same relation, keep it.
    if(currentRule && (this.props.columns[nextColumn].relations[currentRule.relation] !== undefined)) {
      return currentRule.relation;
    }
    // Otherwise, return the first relation for the new column.
    return Object.keys(this.props.columns[nextColumn].relations)[0];
  }

  /**
   * Given the column and relation we're changing to and the current condition,
   * return the value that the condition should be changed to.
   *
   * @param nextColumn
   * @param nextRelation
   * @param currentRule
   */
  getNextCondition(nextColumn, nextRelation, currentRule) {
    // If the new relation provides for the same condition type, keep it.
    if(currentRule) {
      const currentConditionType = this.props.columns[currentRule.column].relations[currentRule.relation].type;
      const nextConditionType = this.props.columns[nextColumn].relations[nextRelation].type;

      if(currentConditionType === nextConditionType) {
        return currentRule.condition;
      }
    }

    // Otherwise, reset the condition to an empty string.
    return '';
  }

  /**
   * Handle the updating of a rule in our array in an immutable manner.
   *
   * @param index
   * @param updates
   */
  updateRule(index, updates) {
    let updatedRule = Object.assign({}, this.state.rules[index], updates);

    // Ensure only valid variables are present in the rule
    const columnPath = this.props.columns[updatedRule.column].column;
    const columnVariables = RulesEditor.getColumnPathVariables(columnPath);
    Object.keys(updatedRule).forEach(function (key) {
      if ('$' === key[0] && -1 === columnVariables.indexOf(key)) {
        delete updatedRule[key];
      }
    });

    this.setState({
      rules: [
        ...this.state.rules.slice(0, index),
        updatedRule,
        ...this.state.rules.slice(index + 1)
      ]
    });
  }

  /**
   * Render the Rules Editor.
   */
  render() {
    const { name } = this.props;
    const { rules } = this.state;

    const ruleElements = rules.map((rule, i) => {
      return <RulesEditorRule
        key={i}
        rule={rule}
        columns={this.props.columns}
        onRemove={this.onRemoveRule.bind(this, i)}
        onColumnChange={this.onRuleColumnChange.bind(this, i)}
        onRelationChange={this.onRuleRelationChange.bind(this, i)}
        onConditionChange={this.onRuleConditionChange.bind(this, i)}
        onVariableChange={this.onRuleVariableChange.bind(this, i)}
        ruleCount={rules.length}
        blankOk = {this.props.blankOk}
      />
    });

    // Convert the current rules JSON into a format using the correct column
    // format used by our more advanced key checker.
    const rulesJSON = JSON.stringify(this.state.rules.map((rule, i) => {
      return Object.assign({}, rule, {
        column: this.props.columns[rule.column].column
      });
    }));

    return(
      <CardSection>
        <div className="next-grid next-grid--no-outside-padding">
          <div style={{ width: '100%'}}>
            {ruleElements}
          </div>
        </div>
        <Button onClick={this.onAddRule.bind(this)}>
          Add another condition
        </Button>
        <input type="hidden" name={name} value={rulesJSON} />
      </CardSection>
    );
  }

  /**
   * Get the variable names present in a column definition
   *
   * @param column
   * @returns {Array.<String>}
   */
  static getColumnPathVariables(column) {
    return column.split(/[^$a-z_A-Z]/).filter((key) => '$' === key[0]);
  }

  /**
   * Return a relations object, which is just the passed array
   * turned into an object which is keyed by the `relation` value
   *
   * @param relations
   * @returns {{}}
   */
  static buildRelationsObj(relations) {
    var relationsObj = {};

    relations.forEach(function (relation) {
      return relationsObj[relation.relation] = relation;
    });

    return relationsObj;
  }

}


RulesEditor.EQUALS_STRING = {
  label: 'is equal to',
  relation: 'is_equal_to',
  type: 'text'
};
RulesEditor.NOT_EQUALS_STRING = {
  label: 'is not equal to',
  relation: 'is_not_equal_to',
  type: 'text'
};
RulesEditor.EQUALS_COUNTRY_CODE = {
  label: 'is equal to',
  relation: 'is_equal_to',
  type: 'country_code'
};
RulesEditor.NOT_EQUALS_COUNTRY_CODE = {
  label: 'is not equal to',
  relation: 'is_not_equal_to',
  type: 'country_code'
};
RulesEditor.CONTAINS_STRING = {
  label: 'contains',
  relation: 'contains_string',
  type: 'text'
};
RulesEditor.DOES_NOT_CONTAIN_STRING = {
  label: 'does not contain',
  relation: 'does_not_contain_string',
  type: 'text'
};
RulesEditor.EQUALS_TAG = {
  label: 'is equal to',
  relation: 'find_in_set',
  type: 'tag'
};
RulesEditor.GREATER_THAN = {
  label: 'is greater than',
  relation: 'is_greater_than',
  type: 'numeric'
};
RulesEditor.LESS_THAN = {
  label: 'is less than',
  relation: 'is_less_than',
  type: 'numeric'
};

const RulesEditorRule = ({ rule, columns, onRemove, onColumnChange, onVariableChange, onRelationChange, onConditionChange, ruleCount, blankOk }) => {
  const { column, relation, condition } = rule;

  const currentColumn = columns[column];
  const currentRelation = currentColumn.relations[relation];

  let conditionEditor = null;
  switch(currentRelation.type) {
    case 'text':
    case 'numeric':
    case 'tag':
      conditionEditor = <RulesEditorConditionInputText condition={condition} onChange={onConditionChange} />;
      break;
    case 'country_code':
      conditionEditor = <RulesEditorConditionInputCountryCode condition={condition} onChange={onConditionChange} />;
      break;
  }

  let deleteIconCell = null;
  if(ruleCount > 1 || blankOk === true) {
    deleteIconCell = (
      <div className="sl">
        <button type="button" className="btn btn--icon" onClick={onRemove}>
          <i className="ico ico-14-svg ico-delete" />
        </button>
      </div>
    );
  }

  const columnVariables = RulesEditor.getColumnPathVariables(currentColumn.column);

  let variablesEditor = columnVariables.map(function(name) {
    return (
      <div className="next-grid__cell" key={name}>
        <RulesEditorVariableInput name={name} value={rule[name]} onChange={onVariableChange.bind(this, name)} />
      </div>
    );
  });

  return (
    <div>
      <div className="next-grid next-grid--no-padding next-grid--compact">
        <div className="next-grid__cell">
          <div className="next-grid next-grid--compact next-grid--no-outside-padding">
            <div className="next-grid__cell">
              <RulesEditorColumnSelect currentColumnName={column} columns={columns} onChange={onColumnChange} />
            </div>
            {variablesEditor}
            <div className="next-grid__cell">
              <RulesEditorRelationSelect currentRelationName={relation} relations={currentColumn.relations} onChange={onRelationChange} />
            </div>
            <div className="next-grid__cell">
              {conditionEditor}
            </div>
          </div>
        </div>
        {deleteIconCell}
      </div>
      <hr className="next-card__section__separator" />
    </div>
  );

};

const RulesEditorColumnSelect = ({ currentColumnName, columns, onChange }) => {
  const options = Object.keys(columns).map((columnName) => {
    return { label: columns[columnName].label, value: columnName }
  });

  return <InputSelect options={options} value={currentColumnName} onChange={onChange} label="Field" labelHidden={true} />;
};

const RulesEditorVariableInput = ({ name, value, onChange }) => {

  const handleChange = (e) => {
    onChange && onChange(e);
  };

  let label = name.substr(1).trim().replace( /([A-Z])/g, " $1" );
  label = label.charAt(0).toUpperCase() + label.substr(1);

  return (
    <InputText value={value} onChange={handleChange} label={label} labelHidden={true} placeholder={label} required={true} />
  );
};

const RulesEditorRelationSelect = ({ currentRelationName, relations, onChange }) => {
  const options = Object.keys(relations).map((relationName) => {
    return { label: relations[relationName].label, value: relationName }
  });

  return <InputSelect options={options} value={currentRelationName} onChange={onChange} label="Relation" labelHidden={true} />;
};

const RulesEditorConditionInputText = ({ condition, onChange }) => {

  const handleChange = (e) => {
    onChange && onChange(e);
  };

  return (
    <InputText value={condition} onChange={handleChange} label="Value" labelHidden={true} />
  );

};

const RulesEditorConditionInputCountryCode = ({ condition, onChange }) => {

  const handleChange = (e) => {
    onChange && onChange(e);
  };

  const countryOptions = [{"label":"Australia","value":"AU"},{"label":"Canada","value":"CA"},{"label":"United Kingdom","value":"GB"},{"label":"United States","value":"US"},{"label":"Afghanistan","value":"AF"},{"label":"Åland Islands","value":"AX"},{"label":"Albania","value":"AL"},{"label":"Algeria","value":"DZ"},{"label":"Andorra","value":"AD"},{"label":"Angola","value":"AO"},{"label":"Anguilla","value":"AI"},{"label":"Antigua & Barbuda","value":"AG"},{"label":"Argentina","value":"AR"},{"label":"Armenia","value":"AM"},{"label":"Aruba","value":"AW"},{"label":"Australia","value":"AU"},{"label":"Austria","value":"AT"},{"label":"Azerbaijan","value":"AZ"},{"label":"Bahamas","value":"BS"},{"label":"Bahrain","value":"BH"},{"label":"Bangladesh","value":"BD"},{"label":"Barbados","value":"BB"},{"label":"Belarus","value":"BY"},{"label":"Belgium","value":"BE"},{"label":"Belize","value":"BZ"},{"label":"Benin","value":"BJ"},{"label":"Bermuda","value":"BM"},{"label":"Bhutan","value":"BT"},{"label":"Bolivia","value":"BO"},{"label":"Bosnia & Herzegovina","value":"BA"},{"label":"Botswana","value":"BW"},{"label":"Bouvet Island","value":"BV"},{"label":"Brazil","value":"BR"},{"label":"British Indian Ocean Territory","value":"IO"},{"label":"British Virgin Islands","value":"VG"},{"label":"Brunei","value":"BN"},{"label":"Bulgaria","value":"BG"},{"label":"Burkina Faso","value":"BF"},{"label":"Burundi","value":"BI"},{"label":"Cambodia","value":"KH"},{"label":"Cameroon","value":"CM"},{"label":"Canada","value":"CA"},{"label":"Cape Verde","value":"CV"},{"label":"Cayman Islands","value":"KY"},{"label":"Central African Republic","value":"CF"},{"label":"Chad","value":"TD"},{"label":"Chile","value":"CL"},{"label":"China","value":"CN"},{"label":"Christmas Island","value":"CX"},{"label":"Cocos (Keeling) Islands","value":"CC"},{"label":"Colombia","value":"CO"},{"label":"Comoros","value":"KM"},{"label":"Congo - Brazzaville","value":"CG"},{"label":"Congo - Kinshasa","value":"CD"},{"label":"Cook Islands","value":"CK"},{"label":"Costa Rica","value":"CR"},{"label":"Croatia","value":"HR"},{"label":"Cuba","value":"CU"},{"label":"Curaçao","value":"CW"},{"label":"Cyprus","value":"CY"},{"label":"Czech Republic","value":"CZ"},{"label":"Côte d’Ivoire","value":"CI"},{"label":"Denmark","value":"DK"},{"label":"Djibouti","value":"DJ"},{"label":"Dominica","value":"DM"},{"label":"Dominican Republic","value":"DO"},{"label":"Ecuador","value":"EC"},{"label":"Egypt","value":"EG"},{"label":"El Salvador","value":"SV"},{"label":"Equatorial Guinea","value":"GQ"},{"label":"Eritrea","value":"ER"},{"label":"Estonia","value":"EE"},{"label":"Ethiopia","value":"ET"},{"label":"Falkland Islands","value":"FK"},{"label":"Faroe Islands","value":"FO"},{"label":"Fiji","value":"FJ"},{"label":"Finland","value":"FI"},{"label":"France","value":"FR"},{"label":"French Guiana","value":"GF"},{"label":"French Polynesia","value":"PF"},{"label":"French Southern Territories","value":"TF"},{"label":"Gabon","value":"GA"},{"label":"Gambia","value":"GM"},{"label":"Georgia","value":"GE"},{"label":"Germany","value":"DE"},{"label":"Ghana","value":"GH"},{"label":"Gibraltar","value":"GI"},{"label":"Greece","value":"GR"},{"label":"Greenland","value":"GL"},{"label":"Grenada","value":"GD"},{"label":"Guadeloupe","value":"GP"},{"label":"Guatemala","value":"GT"},{"label":"Guernsey","value":"GG"},{"label":"Guinea","value":"GN"},{"label":"Guinea-Bissau","value":"GW"},{"label":"Guyana","value":"GY"},{"label":"Haiti","value":"HT"},{"label":"Heard & McDonald Islands","value":"HM"},{"label":"Honduras","value":"HN"},{"label":"Hong Kong SAR China","value":"HK"},{"label":"Hungary","value":"HU"},{"label":"Iceland","value":"IS"},{"label":"India","value":"IN"},{"label":"Indonesia","value":"ID"},{"label":"Iran","value":"IR"},{"label":"Iraq","value":"IQ"},{"label":"Ireland","value":"IE"},{"label":"Isle of Man","value":"IM"},{"label":"Israel","value":"IL"},{"label":"Italy","value":"IT"},{"label":"Jamaica","value":"JM"},{"label":"Japan","value":"JP"},{"label":"Jersey","value":"JE"},{"label":"Jordan","value":"JO"},{"label":"Kazakhstan","value":"KZ"},{"label":"Kenya","value":"KE"},{"label":"Kiribati","value":"KI"},{"label":"Kosovo","value":"KV"},{"label":"Kuwait","value":"KW"},{"label":"Kyrgyzstan","value":"KG"},{"label":"Laos","value":"LA"},{"label":"Latvia","value":"LV"},{"label":"Lebanon","value":"LB"},{"label":"Lesotho","value":"LS"},{"label":"Liberia","value":"LR"},{"label":"Libya","value":"LY"},{"label":"Liechtenstein","value":"LI"},{"label":"Lithuania","value":"LT"},{"label":"Luxembourg","value":"LU"},{"label":"Macau SAR China","value":"MO"},{"label":"Macedonia","value":"MK"},{"label":"Madagascar","value":"MG"},{"label":"Malawi","value":"MW"},{"label":"Malaysia","value":"MY"},{"label":"Maldives","value":"MV"},{"label":"Mali","value":"ML"},{"label":"Malta","value":"MT"},{"label":"Martinique","value":"MQ"},{"label":"Mauritania","value":"MR"},{"label":"Mauritius","value":"MU"},{"label":"Mayotte","value":"YT"},{"label":"Mexico","value":"MX"},{"label":"Moldova","value":"MD"},{"label":"Monaco","value":"MC"},{"label":"Mongolia","value":"MN"},{"label":"Montenegro","value":"ME"},{"label":"Montserrat","value":"MS"},{"label":"Morocco","value":"MA"},{"label":"Mozambique","value":"MZ"},{"label":"Myanmar (Burma)","value":"MM"},{"label":"Namibia","value":"NA"},{"label":"Nauru","value":"NR"},{"label":"Nepal","value":"NP"},{"label":"Netherlands","value":"NL"},{"label":"Netherlands Antilles","value":"AN"},{"label":"New Caledonia","value":"NC"},{"label":"New Zealand","value":"NZ"},{"label":"Nicaragua","value":"NI"},{"label":"Niger","value":"NE"},{"label":"Nigeria","value":"NG"},{"label":"Niue","value":"NU"},{"label":"Norfolk Island","value":"NF"},{"label":"North Korea","value":"KP"},{"label":"Norway","value":"NO"},{"label":"Oman","value":"OM"},{"label":"Pakistan","value":"PK"},{"label":"Palestinian Territories","value":"PS"},{"label":"Panama","value":"PA"},{"label":"Papua New Guinea","value":"PG"},{"label":"Paraguay","value":"PY"},{"label":"Peru","value":"PE"},{"label":"Philippines","value":"PH"},{"label":"Pitcairn Islands","value":"PN"},{"label":"Poland","value":"PL"},{"label":"Portugal","value":"PT"},{"label":"Qatar","value":"QA"},{"label":"Réunion","value":"RE"},{"label":"Romania","value":"RO"},{"label":"Russia","value":"RU"},{"label":"Rwanda","value":"RW"},{"label":"Samoa","value":"WS"},{"label":"San Marino","value":"SM"},{"label":"São Tomé & Príncipe","value":"ST"},{"label":"Saudi Arabia","value":"SA"},{"label":"Senegal","value":"SN"},{"label":"Serbia","value":"RS"},{"label":"Seychelles","value":"SC"},{"label":"Sierra Leone","value":"SL"},{"label":"Singapore","value":"SG"},{"label":"Sint Maarten","value":"SX"},{"label":"Slovakia","value":"SK"},{"label":"Slovenia","value":"SI"},{"label":"Solomon Islands","value":"SB"},{"label":"Somalia","value":"SO"},{"label":"South Africa","value":"ZA"},{"label":"South Georgia & South Sandwich Islands","value":"GS"},{"label":"South Korea","value":"KR"},{"label":"Spain","value":"ES"},{"label":"Sri Lanka","value":"LK"},{"label":"St. Barthélemy","value":"BL"},{"label":"St. Helena","value":"SH"},{"label":"St. Kitts & Nevis","value":"KN"},{"label":"St. Lucia","value":"LC"},{"label":"St. Martin","value":"MF"},{"label":"St. Pierre & Miquelon","value":"PM"},{"label":"St. Vincent & Grenadines","value":"VC"},{"label":"Sudan","value":"SD"},{"label":"Suriname","value":"SR"},{"label":"Svalbard & Jan Mayen","value":"SJ"},{"label":"Swaziland","value":"SZ"},{"label":"Sweden","value":"SE"},{"label":"Switzerland","value":"CH"},{"label":"Syria","value":"SY"},{"label":"Taiwan","value":"TW"},{"label":"Tajikistan","value":"TJ"},{"label":"Tanzania","value":"TZ"},{"label":"Thailand","value":"TH"},{"label":"Timor-Leste","value":"TL"},{"label":"Togo","value":"TG"},{"label":"Tokelau","value":"TK"},{"label":"Tonga","value":"TO"},{"label":"Trinidad & Tobago","value":"TT"},{"label":"Tunisia","value":"TN"},{"label":"Turkey","value":"TR"},{"label":"Turkmenistan","value":"TM"},{"label":"Turks & Caicos Islands","value":"TC"},{"label":"Tuvalu","value":"TV"},{"label":"U.S. Outlying Islands","value":"UM"},{"label":"Uganda","value":"UG"},{"label":"Ukraine","value":"UA"},{"label":"United Arab Emirates","value":"AE"},{"label":"United Kingdom","value":"GB"},{"label":"United States","value":"US"},{"label":"Uruguay","value":"UY"},{"label":"Uzbekistan","value":"UZ"},{"label":"Vanuatu","value":"VU"},{"label":"Vatican City","value":"VA"},{"label":"Venezuela","value":"VE"},{"label":"Vietnam","value":"VN"},{"label":"Wallis & Futuna","value":"WF"},{"label":"Western Sahara","value":"EH"},{"label":"Yemen","value":"YE"},{"label":"Zambia","value":"ZM"},{"label":"Zimbabwe","value":"ZW"}];

  return (
    <InputSelect options={countryOptions} value={condition} onChange={handleChange} label="Value" labelHidden={true} />
  );

};
