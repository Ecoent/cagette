import { Test, TestingModule } from '@nestjs/testing';
import { MangopayController } from './mangopay.controller';

describe('Mangopay Controller', () => {
  let controller: MangopayController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MangopayController],
    }).compile();

    controller = module.get<MangopayController>(MangopayController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
