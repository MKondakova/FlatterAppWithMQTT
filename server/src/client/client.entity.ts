import {
  Column,
  Entity,
  JoinTable,
  ManyToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';

import { Sensor } from '../sensor/sensor.entity';

@Entity()
export class Client {
  @PrimaryGeneratedColumn()
  public id: number;

  @Column('text')
  public username: string;

  @Column('text')
  public password: string;

  @ManyToMany(() => Sensor, (sensor) => sensor.clients)
  @JoinTable()
  sensors: Sensor[];
}
