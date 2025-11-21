import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  icon: string;
  description: ReactNode;
  link: string;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'WCAG AAA Accessible Colors',
    icon: '🎨',
    description: (
      <>
        Our complete color palette featuring Sage Green, Sky Blue, Amber, and Purple
        ensures WCAG AAA compliance for all text combinations. Every color is tested
        and documented with contrast ratios.
      </>
    ),
    link: '/design-system/colors',
  },
  {
    title: 'Open Source Design Tools',
    icon: '🛠️',
    description: (
      <>
        Build professional designs at $0/month using Penpot, our Figma alternative.
        Complete setup guides, component libraries, and integration workflows included
        for seamless design-to-code handoff.
      </>
    ),
    link: '/tools/penpot-setup',
  },
  {
    title: 'Responsive-First Workflow',
    icon: '📱',
    description: (
      <>
        Design for all screens with our comprehensive breakpoint system (375px to 1920px).
        Includes ASCII wireframes for rapid iteration and multi-resolution mockup workflows
        optimized for modern web development.
      </>
    ),
    link: '/responsive/breakpoints',
  },
];

function Feature({title, icon, description, link}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <div className={styles.featureIcon}>{icon}</div>
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
        <a href={link} className="button button--sm button--outline button--primary">
          Learn More →
        </a>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="text--center margin-bottom--lg">
          <Heading as="h2">Why VLN Design Standards?</Heading>
          <p className="hero__subtitle" style={{marginTop: '1rem'}}>
            A comprehensive design system built for engineers, by engineers
          </p>
        </div>
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
        <div className="text--center margin-top--xl">
          <p style={{fontSize: '1.1rem', color: 'var(--ifm-color-emphasis-700)'}}>
            Ready to start building with VLN standards?
          </p>
          <a href="/getting-started" className="button button--primary button--lg">
            Get Started Now →
          </a>
          <div style={{marginTop: '2rem'}}>
            <a href="https://design.penpot.app" target="_blank" rel="noopener noreferrer" style={{marginRight: '1.5rem'}}>
              Open Penpot →
            </a>
            <a href="https://github.com/Fused-Gaming/DevOps" target="_blank" rel="noopener noreferrer">
              View on GitHub →
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
