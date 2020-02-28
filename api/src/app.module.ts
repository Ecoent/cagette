import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MangopayModule } from './mangopay/mangopay.module';
import { ConfigModule } from "@nestjs/config";

@Module({
  imports: [
    TypeOrmModule.forRoot(),
    ConfigModule.forRoot({isGlobal: true}),
    UsersModule,
    MangopayModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
