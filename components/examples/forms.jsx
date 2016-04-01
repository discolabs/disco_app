import React from 'react';
import Card from 'components/card';
import CardSection from 'components/card-section';
import InputCheckbox from 'components/input-checkbox';
import InputRadio from 'components/input-radio';
import InputSelect from 'components/input-select';
import InputText from 'components/input-text';
import InputTextarea from 'components/input-textarea';
import InputConnectedDropdown from 'components/input-connected-dropdown';
import UILayout from 'components/ui-layout';
import UILayoutSections from 'components/ui-layout-sections';
import UILayoutSection from 'components/ui-layout-section';

const testChange = val => {console.log(val)};

const Forms = (props) => {
  return (
    <UILayout>
      <UILayoutSections>
        <UILayoutSection>
          <div className="ui-layout__item">

            <Card>

              <CardSection title="Input Text">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  onChange={testChange}
                  placeholder="Your product title"
                  helpMessage="Field specific help message would live here."
                />
              </CardSection>

              <CardSection title="Input Text Disabled">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  onChange={testChange}
                  placeholder="Your product title"
                  disabled={true}
                />
              </CardSection>

              <CardSection title="Input Text Error">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  onChange={testChange}
                  placeholder="Your product title"
                  error={true}
                />
              </CardSection>

              <CardSection title="Radio input">
                <InputRadio
                  name="testRadio"
                  onChange={testChange}
                  label="Option 1"
                  value="Option 1"
                  checked={true}/>
                <InputRadio
                  name="testRadio"
                  onChange={testChange}
                  label="Option 2"
                  value="Option 2"/>
                <InputRadio
                  name="testRadio"
                  onChange={testChange}
                  label="Option 3"
                  value="Option 3"/>
              </CardSection>

              <CardSection title="Select input">
                <InputSelect
                  label="Select"
                  name="select"
                  onChange={testChange}
                  options={[ { label: 'select 1', value: '1'}, { label: 'select 2', value: '2' } ]}
                />
              </CardSection>

              <CardSection title="Textarea input">
                <InputTextarea
                  label="Product description"
                  name="product_description"
                  onChange={testChange}
                  placeholder="This product will substantially and dramatically change and improve your quality of life. Natural. Organic. Renewable. Disposable."
                />
              </CardSection>

              <CardSection title="Checkbox Input">
                <InputCheckbox
                  label="Customer accepts marketing"
                  name="customer_accepts_marketing"
                  onChange={testChange}
                />
              </CardSection>

              <CardSection title="Connected Inputs">
                <InputConnectedDropdown
                  defaultInputValue="10"
                  defaultSelectValue="lb"
                  inputName="weight_value"
                  inputOnChange={testChange}
                  label="Weight"
                  options={['kg', 'g', 'lb', 'oz']}
                  selectName="weight"
                  selectOnChange={testChange}
                />
              </CardSection>

            </Card>

          </div>
        </UILayoutSection>
      </UILayoutSections>
    </UILayout>
  );
}

export default Forms;
