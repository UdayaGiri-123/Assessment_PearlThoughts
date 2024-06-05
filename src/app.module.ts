import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { NotificationModule } from './notification/notification.module';
import { EmailService } from './email/email.service';
import { EmailModule } from './email/email.module';

@Module({
  imports: [NotificationModule, EmailModule],
  controllers: [AppController],
  providers: [AppService, EmailService],
})
export class AppModule {}
