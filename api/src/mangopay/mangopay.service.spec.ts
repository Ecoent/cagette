import { Test, TestingModule } from '@nestjs/testing';
import { MangopayService } from './mangopay.service';

describe('MangopayService', () => {
  let service: MangopayService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MangopayService],
    }).compile();

    service = module.get<MangopayService>(MangopayService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
