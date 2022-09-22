import { Injectable } from '@nestjs/common';
import { ServerRunnerService } from './server-runner.service';

@Injectable()
export class PublishMessageService {
  public execute(data: { topic: string; payload: string }) {
    const server = ServerRunnerService.AedesServer;
    server.publish(
      {
        topic: data.topic,
        payload: Buffer.from(data.payload),
        cmd: 'publish',
        dup: false,
        retain: false,
        qos: 1,
      },
      (error) => {
        console.log('ERROR WHILE PUBLISHING:', error);
      },
    );
  }
}
