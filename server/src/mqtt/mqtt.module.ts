import { PublishMessageService, ServerRunnerService } from './service';

import { Module } from '@nestjs/common';

@Module({
  providers: [ServerRunnerService, PublishMessageService],
  exports: [ServerRunnerService, PublishMessageService],
})
export class MqttModule {}
