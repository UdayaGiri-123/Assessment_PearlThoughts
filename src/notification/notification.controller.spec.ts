import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { NotificationModule } from './notification.module';
import { ConfigModule } from '@nestjs/config';

describe('NotificationController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [NotificationModule, ConfigModule.forRoot()],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.listen(3000);  // Ensure the app listens on port 3000
  });

  afterAll(async () => {
    await app.close();
  });

  it('should be running on port 3000 and return 404 for GET /', () => {
    return request('http://localhost:3000')
      .get('/')
      .expect(404);  // Expecting 404 since the root route is not defined
  });

  it('/notification (POST)', () => {
    return request('http://localhost:3000')
      .post('/notification')
      .send({ message: 'Hello, this is a test notification!' })
      .expect(201)
      .expect('Content-Type', /json/)
      .expect({ success: true });
  });
});
