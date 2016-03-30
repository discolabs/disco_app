import React from 'react';
import Card from 'components/card';
import CardSection from 'components/card-section';
import InputRadio from 'components/input-radio';
import InputSelect from 'components/input-select';
import InputText from 'components/input-text';

const Forms = (props) => {
  return (
    <div className="ui-layout">
      <div className="ui-layout__sections">
        <div className="ui-layout__section">
          <div className="ui-layout__item">

            <Card>

              <CardSection title="Input Text">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  placeholder="Your product title"
                  helpMessage="Field specific help message would live here."
                />
              </CardSection>

              <CardSection title="Input Text Disabled">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  placeholder="Your product title"
                  disabled={true}
                />
              </CardSection>

              <CardSection title="Input Text Error">
                <InputText
                  label="Product Title"
                  name="productTitle"
                  placeholder="Your product title"
                  error={true}
                />
              </CardSection>

              <CardSection title="Radio input">
                <InputRadio/>
              </CardSection>

              <CardSection title="Select input">
                <InputSelect
                  label="Select"
                  name="select"
                  options={[ { label: 'select 1', value: '1'}, { label: 'select 2', value: '2' } ]}
                />
              </CardSection>

            </Card>

          </div>
        </div>
      </div>
    </div>
  );
}

export default Forms;
