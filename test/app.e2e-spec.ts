import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';
import { NotificationModule } from './../src/notification/notification.module';
import { ConfigModule } from '@nestjs/config';
import { json, text } from 'stream/consumers';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule, NotificationModule, ConfigModule.forRoot()],
    }).compile();

  });

  it('should be running on port 3000 and return 404 for GET /', async () => {
    const response = await request("http://localhost:3000").get('/notification');
    expect(response.status).toBe(404);  // Expecting 404 since the root route is not defined
  }); 

  it('/notification (GET)', async () => {
    const response = await request("http://localhost:3000").get('/');
    expect(response.status).toBe(200);
  });

  it('/notification (POST)', async () => {
    const response = await request("http://localhost:3000")
      .post('/notification')
      .send({ message: 'Hello, this is a test notification!' });
    expect(response.status).toBe(500);
  });
});
