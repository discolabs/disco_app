import React from 'react';
import UIAnnotatedSection from 'components/ui-annotated-section';
import Card from 'components/card';
import CardSection from 'components/card-section';
import InputRadio from 'components/input-radio';
import UIBanner from 'components/ui-banner';

const Modules = (props) => {
  return (
    <div>
      <UIAnnotatedSection
        title="Section Heading"
        description="Description of section"
      >
        <Card>
          <CardSection>
            Section content
          </CardSection>
        </Card>
      </UIAnnotatedSection>


      <UIAnnotatedSection
        title="Notice banner"
        description="Description of section"
      >
        <Card>
          <CardSection>
            <UIBanner
              title="General banner title"
              description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus."/>

            <InputRadio name="notice_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="notice_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>
      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Warning banner"
        description="Description of section"
      >
        <Card>
          <CardSection>
            <UIBanner
              title="General banner title"
              type="warning"
              description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus."/>

            <InputRadio name="warning_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="warning_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>
      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Error banner"
        description="Description of section"
      >
        <Card>
          <CardSection>
            <UIBanner
              title="General banner title"
              type="error"
              description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus."/>

            <InputRadio name="error_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="error_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>
      </UIAnnotatedSection>

    </div>
  )
};

export default Modules;
