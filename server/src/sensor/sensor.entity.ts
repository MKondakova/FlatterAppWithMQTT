import { Column, Entity, ManyToMany, PrimaryGeneratedColumn } from 'typeorm';

import { Client } from '../client/client.entity';

@Entity()
export class Sensor {
  @PrimaryGeneratedColumn()
  public id: number;

  @Column({ type: 'uuid' })
  public guid: string;

  @Column('text')
  public title: string;

  @ManyToMany(() => Client, (client) => client.sensors)
  public clients: Client[];
}
