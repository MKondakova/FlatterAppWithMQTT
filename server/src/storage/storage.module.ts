import { Module } from '@nestjs/common';
import { StorageHandlerService } from './services';

@Module({
  imports: [],
  providers: [StorageHandlerService],
  exports: [StorageHandlerService],
})
export class StorageModule {}
