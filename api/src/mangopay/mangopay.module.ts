import { Module } from '@nestjs/common';
import { MangopayController } from './mangopay.controller';
import { MangopayService } from './mangopay.service';

@Module({
  controllers: [MangopayController],
  providers: [MangopayService]
})
export class MangopayModule {}
