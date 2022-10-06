import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

import { Subscription } from '@/subscription/subscription.entity';

@Entity()
export class Client {
  @PrimaryGeneratedColumn()
  public id: number;

  @Column('text')
  public username: string;

  @Column('text')
  public password: string;

  @OneToMany(() => Subscription, (subscription) => subscription.client)
  subscriptions: Subscription[];
}
