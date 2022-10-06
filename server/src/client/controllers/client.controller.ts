import { CreateClientService, LoginClientService } from '../services';

import { ClientCreateDto } from '../dto';
import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

@Controller('')
export class ClientController {
  public constructor(
    private readonly createClientService: CreateClientService,
    private readonly loginClientService: LoginClientService,
  ) {}
  @MessagePattern('client/create')
  async createClient(data: ClientCreateDto) {
    await this.createClientService.execute(data);
  }

  @MessagePattern('client/login')
  async loginClient(data: ClientCreateDto) {
    await this.loginClientService.execute(data);
  }
}
