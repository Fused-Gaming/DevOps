import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import VLNShowcase from '@site/src/components/VLNShowcase';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          VLN Design Standards
        </Heading>
        <p className="hero__subtitle">
          Design system, UI guidelines, and engineering standards for crafting exceptional VLN experiences
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/getting-started">
            Get Started →
          </Link>
          <Link
            className="button button--outline button--lg"
            style={{marginLeft: '1rem'}}
            to="/design-system/colors">
            Explore Design System
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title="Home"
      description="VLN Design Standards - Design system, UI guidelines, and engineering standards for VLN products">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
        <VLNShowcase />
      </main>
    </Layout>
  );
}
