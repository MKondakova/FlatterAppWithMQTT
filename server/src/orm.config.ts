import { ConnectionOptions } from 'typeorm';

const db = {
  host: 'localhost',
  port: 5432,
  username: 'postgres',
  password: 'postgres',
  database: 'mqtt',
};
const config: ConnectionOptions = {
  type: 'postgres',
  host: db.host,
  port: db.port,
  username: db.username,
  password: db.password,
  database: db.database,
  entities: [__dirname + '/**/*.entity{.ts,.js}'],
  // ВАЖНО: Должно быть false, чтобы применять МИГРАЦИИ РУКАМИ иначе TypeORM будет пытаться
  // применять миграции при каждом запуске приложения.
  synchronize: false,
  migrationsTableName: 'migration',
  migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
  cli: {
    migrationsDir: 'src/migrations',
  },
  logging: false,
};

export = config;
