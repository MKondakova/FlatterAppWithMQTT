import { IsString, MaxLength, MinLength } from 'class-validator';

export class ClientCreateDto {
  @IsString()
  @MaxLength(8)
  @MinLength(2)
  public readonly username: string;

  @IsString()
  @MaxLength(8)
  @MinLength(2)
  public readonly password: string;
}
