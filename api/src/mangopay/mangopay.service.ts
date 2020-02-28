import { Injectable } from '@nestjs/common';
import MangoPay = require('mangopay2-nodejs-sdk');
import { ConfigModule, ConfigService } from '@nestjs/config';

/**
 * Mangopay Service
 * @doc https://github.com/Mangopay/mangopay2-nodejs-sdk/blob/HEAD/docs/README.md
 */
@Injectable()
export class MangopayService {

    constructor(private readonly config:ConfigService){

    }

    init(){

        let api = new MangoPay({
            clientId: this.config.get<string>("MANGOPAY_CLIENT_ID"),
            clientApiKey: this.config.get<string>("MANGOPAY_CLIENT_API_KEY"),            
            baseUrl: this.config.get<string>("MANGOPAY_BASE_URL"),
            apiVersion : 'v2.01',
            logClass : function() {console.log(arguments)},
        });

        return api.Users.get('74612471');

    }
}
