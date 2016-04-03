import React from 'react';
import UIAnnotatedSection from 'components/ui-annotated-section';
import Card from 'components/card';
import CardSection from 'components/card-section';
import InputRadio from 'components/input-radio';
import UIBanner from 'components/ui-banner';
import UIBannerContent from 'components/ui-banner-content';
import UIBannerContentButton from 'components/ui-banner-content-button';
import UILayout from 'components/ui-layout';
import UILayoutItem from 'components/ui-layout-item';
import UILayoutSection from 'components/ui-layout-section';
import UILayoutSections from 'components/ui-layout-sections';

const Modules = (props) => {
  return (
    <div>

      <UIAnnotatedSection
        title="Section Heading"
        description="Description of section">

        <Card>
          <CardSection>
            Section content
          </CardSection>
        </Card>

      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Notice banner"
        description="Description of section">

        <Card>
          <CardSection>
            <UIBanner type="info">
              <UIBannerContent title="General banner title">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus.
              </UIBannerContent>
            </UIBanner>

            <InputRadio name="notice_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="notice_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>

      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Warning banner"
        description="Description of section">

        <Card>
          <CardSection>
            <UIBanner type="warning">
              <UIBannerContent title="Warning!">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus.
              </UIBannerContent>
            </UIBanner>

            <InputRadio name="warning_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="warning_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>

      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Error banner"
        description="Description of section">
        <Card>
          <CardSection>

            <UIBanner type="error">
              <UIBannerContent title="General banner title">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis leo purus, rhoncus id ultrices vitae, feugiat non neque. Vivamus tempor justo eget odio iaculis faucibus.
              </UIBannerContent>
            </UIBanner>

            <InputRadio name="error_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="error_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>

      </UIAnnotatedSection>

      <UIAnnotatedSection
        title="Success banner"
        description="Description of section">

        <Card>
          <CardSection>
            <UIBanner type="success">

              <UIBannerContent title="Account successfully connected">
                Start using [Sales channel] by <a href="#">creating your first post</a>!
              </UIBannerContent>

            </UIBanner>

            <InputRadio name="error_banner" label="Option 1" value="Option 1"/>
            <InputRadio name="error_banner" label="Option 2" value="Option 2"/>
          </CardSection>
        </Card>

      </UIAnnotatedSection>

      <UILayout>
        <UILayoutSections>
          <UILayoutSection>
            <UILayoutItem>

              <UIBanner type="info">
                <UIBannerContent
                  title="Connect your [Sales channel] account to start selling">
                  Sell directly on [Sales channel name] using Buyable. Let customers buy your products without leaving [Sales channel].
                </UIBannerContent>
              </UIBanner>

              <UIBanner type="warning">
                <UIBannerContentButton
                  title="Connect your [Sales channel] account to start selling"
                  onButtonClick={e => { alert('clicked button') }}
                  buttonText="Change [setting]"
                  onHelpClick={e => { alert('clicked help') }}
                  helpText="Learn more">
                  Sell directly on [Sales channel name] using Buyable. Let customers buy your products without leaving [Sales channel].
                </UIBannerContentButton>
              </UIBanner>

            </UILayoutItem>
          </UILayoutSection>
        </UILayoutSections>
      </UILayout>

    </div>
  );
};

export default Modules;
