import { Controller, Get, Param } from '@nestjs/common';
import { UsersService } from './users.service';
import { User } from 'output/entities/User';

@Controller('users')
export class UsersController {

    constructor(private readonly usersService:UsersService){}

    @Get(':id')
    async findOne(@Param('id') id:string){
        return await this.usersService.findOne(id);

        // if(user){
        //     return JSON.stringify(user);
        // }else{
        //     return "not found";
        // }
    }


    @Get()
    test(){
        return 'wala wala';
    }
}
