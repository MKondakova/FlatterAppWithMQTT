import { Client } from 'src/client/client.entity';
import { Injectable } from '@nestjs/common';
import { Sensor } from 'src/sensor/sensor.entity';

@Injectable()
export class StorageHandlerService {
  public data: {
    clients: Record<string, Client>;
    sensors: Record<string, Sensor>;
  } = { clients: {}, sensors: {} };

  public getClients() {
    return Object.values(this.data.clients);
  }

  public createClient(client: Client) {
    this.data.clients[client.username] = client;
  }
  public getSensors() {
    return Object.values(this.data.sensors);
  }
  public createSensor(sensor: Sensor) {
    this.data.sensors[sensor.title] = sensor;
  }
}
