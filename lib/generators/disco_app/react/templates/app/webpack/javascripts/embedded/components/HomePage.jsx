import React from 'react';
import { EmptyState, FooterHelp, Layout, Link } from '@shopify/polaris';
import EmbeddedPage from './Shared/EmbeddedPage';

const HomePage = props => (
  <EmbeddedPage title="Welcome" {...props}>
    <EmptyState
      action={{
        content: 'Polaris docs',
        external: true,
        url: 'https://polaris.shopify.com/'
      }}
      heading="Booyah!"
      image="https://cdn.shopify.com/s/files/1/0757/9955/files/empty-state.svg"
    >
      <p>Time to build a killer UI</p>
    </EmptyState>
    <Layout.Section>
      <FooterHelp>
        Learn more about{' '}
        <Link url="https://www.discolabs.com/" external>
          Disco
        </Link>
        &apos;s{' '}
        <Link url="https://www.discolabs.com/" external>
          [Disco app]
        </Link>
        .
      </FooterHelp>
    </Layout.Section>
  </EmbeddedPage>
);

export default HomePage;
