import { Controller,Post,Body } from '@nestjs/common';
import { NotificationService } from './notification.service';

@Controller('notification')
export class NotificationController {
    constructor(private readonly notificationService: NotificationService)
    {}
    @Post()
    async notify(@Body('message') message:string){
        return this.notificationService.sendNotification(message);
    }
}
