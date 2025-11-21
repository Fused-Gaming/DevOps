import type {ReactNode} from 'react';
import styles from './styles.module.css';

type VLNBrandedCardProps = {
  title: string;
  description: ReactNode;
  image?: string;
  href?: string;
  variant?: 'sage' | 'sky' | 'amber' | 'purple';
};

export default function VLNBrandedCard({
  title,
  description,
  image,
  href,
  variant = 'sage',
}: VLNBrandedCardProps): ReactNode {
  const CardWrapper = href ? 'a' : 'div';
  const props = href ? { href, target: '_blank', rel: 'noopener noreferrer' } : {};

  return (
    <CardWrapper className={`${styles.brandedCard} ${styles[variant]}`} {...props}>
      {image && (
        <div className={styles.cardImage}>
          <img src={image} alt={title} />
        </div>
      )}
      <div className={styles.cardContent}>
        <h3 className={styles.cardTitle}>{title}</h3>
        <p className={styles.cardDescription}>{description}</p>
      </div>
    </CardWrapper>
  );
}
