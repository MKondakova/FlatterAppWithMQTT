import * as aedes from 'aedes';
import * as net from 'net';

import { Injectable } from '@nestjs/common';

@Injectable()
export class ServerRunnerService {
  public static AedesServer: aedes.Aedes;

  public execute() {
    const server = net.createServer(ServerRunnerService.AedesServer.handle);
    const port = 1883;
    server.listen(port, function () {
      console.log('server started and listening on port ', port);
    });

    ServerRunnerService.AedesServer.on('clientError', (a, e) => {
      console.log(e);
    });
    ServerRunnerService.AedesServer.on('connectionError', (a, e) => {
      console.log(e);
    });
    ServerRunnerService.AedesServer.on(
      'subscribe',
      function (subscriptions, client) {
        console.log(
          'MQTT client \x1b[32m' +
            (client ? client.id : client) +
            '\x1b[0m subscribed to topics: ' +
            subscriptions.map((s) => s.topic).join('\n'),
          'from broker',
          ServerRunnerService.AedesServer.id,
        );
      },
    );

    ServerRunnerService.AedesServer.on(
      'unsubscribe',
      function (subscriptions, client) {
        console.log(
          'MQTT client \x1b[32m' +
            (client ? client.id : client) +
            '\x1b[0m unsubscribed to topics: ' +
            subscriptions.join('\n'),
          'from broker',
          ServerRunnerService.AedesServer.id,
        );
      },
    );

    // fired when a client connects
    ServerRunnerService.AedesServer.on('client', function (client) {
      console.log(
        'Client Connected: \x1b[33m' +
          (client ? client.id : client) +
          '\x1b[0m',
        'to broker',
        ServerRunnerService.AedesServer.id,
      );
    });

    // fired when a client disconnects
    ServerRunnerService.AedesServer.on('clientDisconnect', function (client) {
      console.log(
        'Client Disconnected: \x1b[31m' +
          (client ? client.id : client) +
          '\x1b[0m',
        'to broker',
        ServerRunnerService.AedesServer.id,
      );
    });

    // fired when a message is published
    ServerRunnerService.AedesServer.on(
      'publish',
      async function (packet, client) {
        console.log(
          'Client \x1b[31m' +
            (client
              ? client.id
              : 'BROKER_' + ServerRunnerService.AedesServer.id) +
            '\x1b[0m has published',
          '"' + packet.payload.toString() + '"',
          'on',
          packet.topic,
          'to broker',
          ServerRunnerService.AedesServer.id,
        );
      },
    );
  }
}
