import { ClientCreateDto } from '../dto';
import { Controller } from '@nestjs/common';
import { CreateClientService } from '../services';
import { MessagePattern } from '@nestjs/microservices';

@Controller('')
export class ClientController {
  public constructor(
    private readonly createClientService: CreateClientService,
  ) {}
  @MessagePattern('client/create')
  async createClient(data: ClientCreateDto) {
    await this.createClientService.execute(data);
  }
}
