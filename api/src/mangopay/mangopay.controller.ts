import { Controller, Get } from '@nestjs/common';
import { MangopayService } from './mangopay.service';

@Controller('mangopay')
export class MangopayController {

    constructor(private readonly mangopayService:MangopayService){

    }

    @Get()
    async default(){
        return await this.mangopayService.init();

    }

}
