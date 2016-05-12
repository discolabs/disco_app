import React from 'react';
import Card from 'components/card';
import CardSection from 'components/card-section';
import IconCheckmark from 'components/icon-checkmark';
import IconChevron from 'components/icon-chevron';

const Icons = (props) => {
  return (
    <div className="ui-layout">
      <div className="ui-layout__sections">
        <div className="ui-layout__section">
          <div className="ui-layout__item">

            <Card>
              <CardSection title="Checkmark Icon">
                <IconCheckmark/>
              </CardSection>

              <CardSection title="Chevron Icon Next">
                <IconChevron direction="next"/>
                <IconChevron direction="next" disabled={true}/>
              </CardSection>

              <CardSection title="Chevron Icon Previous">
                <IconChevron direction="previous"/>
                <IconChevron direction="previous" disabled={true}/>
              </CardSection>
            </Card>

          </div>
        </div>
      </div>
    </div>
  )
}

export default Icons;
