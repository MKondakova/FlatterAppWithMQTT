import { Column, Entity, JoinColumn, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

import { Subscription } from '@/subscription/subscription.entity';

@Entity()
export class Sensor {
  @PrimaryGeneratedColumn()
  public id: number;

  @Column({ type: 'uuid' })
  public guid: string;

  @Column('text', {
    default: ''
  })
  public state: string;

  @OneToMany(() => Subscription, (subscription) => subscription.sensor)
  subscriptions: Subscription[];
}
