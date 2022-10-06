import { IsString, IsUUID } from 'class-validator';

export class SensorUpdateDto {
  @IsString()
  public readonly state: string;

  @IsString()
  @IsUUID()
  public readonly guid: string;
}
