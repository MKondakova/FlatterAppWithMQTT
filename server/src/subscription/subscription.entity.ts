import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

import { Client } from '@/client/client.entity';
import { Sensor } from '../sensor/sensor.entity';

@Entity()
export class Subscription {
  @PrimaryGeneratedColumn()
  public id: number;

  @Column('text')
  public title: string;

  @ManyToOne(() => Sensor, (sensor) => sensor.subscriptions)
  sensor: Sensor;

  @ManyToOne(() => Client, (client) => client.subscriptions)
  client: Client;
}
