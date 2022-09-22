export class Client {
  public username: string;
  public password: string;

  public constructor(v: Partial<Client>) {
    Object.assign(this, v);
  }
}
