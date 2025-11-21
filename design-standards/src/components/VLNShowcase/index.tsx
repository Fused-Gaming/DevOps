import type {ReactNode} from 'react';
import Heading from '@theme/Heading';
import VLNBrandedCard from '../VLNBrandedCard';
import styles from './styles.module.css';

export default function VLNShowcase(): ReactNode {
  return (
    <section className={styles.showcase}>
      <div className="container">
        <div className="text--center margin-bottom--lg">
          <Heading as="h2">VLN Ecosystem</Heading>
          <p className="hero__subtitle" style={{marginTop: '1rem'}}>
            Powerful tools and resources for building exceptional products
          </p>
        </div>

        <div className={styles.cardGrid}>
          <VLNBrandedCard
            title="Penpot Design Platform"
            description="Open source design tool with full Figma compatibility. Create professional UI/UX designs, prototypes, and design systems at $0/month."
            href="https://design.penpot.app"
            variant="purple"
            image="/img/vln-social-card.svg"
          />

          <VLNBrandedCard
            title="DevOps Control Panel"
            description="Manage deployments, monitor system status, and track milestones. Built with Next.js 15, React 19, and VLN design standards."
            href="https://vln.gg"
            variant="sky"
            image="/img/vln-social-card.svg"
          />

          <VLNBrandedCard
            title="Design System Components"
            description="Production-ready React components with WCAG AAA accessibility, Tailwind CSS styling, and Framer Motion animations."
            href="/design-system/components"
            variant="sage"
            image="/img/vln-social-card.svg"
          />
        </div>
      </div>
    </section>
  );
}
