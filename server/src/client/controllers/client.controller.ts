import { ClientCreateDto, ClientSubscribeDto } from '../dto';
import {
  CreateClientService,
  GetAllSubscriptionsService,
  LoginClientService,
  SubscribeClientService,
} from '../services';

import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { SubscriptionsFilterDto } from '../dto/subscriptions-filter.dto';

@Controller('')
export class ClientController {
  public constructor(
    private readonly createClientService: CreateClientService,
    private readonly getClientSubscriptionsService: GetAllSubscriptionsService,
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

  @MessagePattern('client/subscriptions')
  async getClientSubscriptions(data: SubscriptionsFilterDto) {
    await this.getClientSubscriptionsService.execute(data);
  }
}
