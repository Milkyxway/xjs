CREATE TABLE `task_supervise_schema`.`user` (
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `userId` INT NOT NULL AUTO_INCREMENT,
  `role` VARCHAR(45) NULL,
  `orgnization` INT NULL,
  PRIMARY KEY (`userId`));
INSERT into user value('admin', 'admin123456', 1, 'section', 0);
INSERT into user value('zonghe', 'zonghe123456', 2, 'section', 1);
INSERT into user value('dangqun', 'dangqun123456', 3, 'section', 2);
INSERT into user value('renli', 'renli123456', 4, 'section', 3);
INSERT into user value('caiwu', 'caiwu123456', 5, 'section', 4);
INSERT into user value('qyfz', 'qyfz123456', 6, 'section', 5);
INSERT into user value('shichang', 'shichang123456', 7, 'section', 6);
INSERT into user value('zhengqi', 'zhengqi123456', 8, 'section', 7);
INSERT into user value('gongke', 'gongke123456', 9, 'section', 8);
INSERT into user value('jszc', 'jszc123456', 10, 'section', 9);
INSERT into user value('gcjs', 'gcjs123456', 11, 'section', 10);
INSERT into user value('abyw', 'abyw123456', 12, 'section', 11);