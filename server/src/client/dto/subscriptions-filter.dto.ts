import { IsString, MaxLength, MinLength } from 'class-validator';

export class SubscriptionsFilterDto {
  @IsString()
  @MaxLength(8)
  @MinLength(2)
  public readonly username: string;
}
