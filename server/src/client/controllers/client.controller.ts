import { CreateClientService, LoginClientService, SubscribeClientService } from '../services';

import { ClientCreateDto } from '../dto';
import { ClientSubscribeDto } from '../dto/client-subscribe.dto';
import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

@Controller('')
export class ClientController {
  public constructor(
    private readonly createClientService: CreateClientService,
    private readonly loginClientService: LoginClientService,
    private readonly subscribeClientService: SubscribeClientService,
  ) {}
  @MessagePattern('client/create')
  async createClient(data: ClientCreateDto) {
    await this.createClientService.execute(data);
  }

  @MessagePattern('client/login')
  async loginClient(data: ClientCreateDto) {
    await this.loginClientService.execute(data);
  }

  @MessagePattern('client/subscribe')
  async subscribeClient(data: ClientSubscribeDto) {
    await this.subscribeClientService.execute(data);
  }
}
