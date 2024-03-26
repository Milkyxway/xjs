CREATE TABLE `task_base`.`task_list` (
  `taskId` int NOT NULL AUTO_INCREMENT,
  `taskContent` varchar(400) DEFAULT NULL,
  `taskGoal` varchar(45) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `category` int DEFAULT NULL,
  `comment` varchar(45) DEFAULT NULL,
  `leadOrg` int DEFAULT NULL,
  `assistOrg` varchar(100) DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `children` int DEFAULT NULL,
  `updateTime` datetime DEFAULT NULL,
  `hasChildren` tinyint DEFAULT NULL,
  `resolveType` varchar(45) DEFAULT NULL,
  `finishTime` datetime DEFAULT NULL,
  `ariseOrg` int DEFAULT NULL,
  `actualFinish` datetime DEFAULT NULL,
  `completeDesc` varchar(45) DEFAULT NULL,
  `delayReason` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`taskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 108 DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;

ALTER TABLE
  `task_base`.`task_list`
ADD
  COLUMN `taskSource` INT NULL
AFTER
  `delayReason`;

CREATE TABLE `task_base`.`subtask_list` (
  `parentId` int DEFAULT NULL,
  `subtaskId` int NOT NULL AUTO_INCREMENT,
  `taskContent` varchar(45) DEFAULT NULL,
  `finishTime` datetime DEFAULT NULL,
  `taskGoal` varchar(45) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `updateTime` datetime DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `leadOrg` int DEFAULT NULL,
  `comment` varchar(45) DEFAULT NULL,
  `completeDesc` varchar(45) DEFAULT NULL,
  `actualFinish` datetime DEFAULT NULL,
  `delayReason` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`subtaskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 47 DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;

CREATE TABLE `bigdata_period`.`user` (
  `username` varchar(16) NOT NULL,
  `password` varchar(32) NOT NULL,
  `userId` int NOT NULL AUTO_INCREMENT,
  `role` varchar(45) DEFAULT NULL,
  `orgnization` int DEFAULT NULL,
  `usernameCn` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;

INSERT into
  `bigdata_period`.`user` value('admin', 'admin123456', 1, 'admin', 0, '管理员');

INSERT into
  `bigdata_period`.`user` value(
    'zonghe',
    'zonghe123456',
    2,
    'section',
    1,
    '综合管理部'
  );

INSERT into
  `bigdata_period`.`user` value(
    'dangqun',
    'dangqun123456',
    3,
    'section',
    2,
    '党群工作部'
  );

INSERT into
  `bigdata_period`.`user` value('renli', 'renli123456', 4, 'section', 3, '人力资源部');

INSERT into
  `bigdata_period`.`user` value('caiwu', 'caiwu123456', 5, 'section', 4, '财务资产部');

INSERT into
  `bigdata_period`.`user` value('qyfz', 'qyfz123456', 6, 'section', 5, '企业发展部');

INSERT into
  `bigdata_period`.`user` value(
    'shichang',
    'shichang123456',
    7,
    'section',
    6,
    '市场运营部'
  );

INSERT into
  `bigdata_period`.`user` value(
    'zhengqi',
    'zhengqi123456',
    8,
    'section',
    7,
    '政企客户部'
  );

INSERT into
  `bigdata_period`.`user` value(
    'gongke',
    'gongke123456',
    9,
    'section',
    8,
    '公共客户部'
  );

INSERT into
  `bigdata_period`.`user` value('jszc', 'jszc123456', 10, 'section', 9, '技术支撑部');

INSERT into
  `bigdata_period`.`user` value('gcjs', 'gcjs123456', 11, 'section', 10, '工程建设部');

INSERT into
  `bigdata_period`.`user` value('abyw', 'abyw123456', 12, 'section', 11, '安播运维部');

CREATE TABLE `subtask_list` (
  `parentId` int DEFAULT NULL,
  `subtaskId` int NOT NULL AUTO_INCREMENT,
  `taskContent` varchar(45) DEFAULT NULL,
  `finishTime` datetime DEFAULT NULL,
  `taskGoal` varchar(45) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `updateTime` datetime DEFAULT NULL,
  `createTime` datetime DEFAULT NULL,
  `leadOrg` int DEFAULT NULL,
  `comment` varchar(45) DEFAULT NULL,
  `completeDesc` varchar(45) DEFAULT NULL,
  `actualFinish` datetime DEFAULT NULL,
  `delayReason` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`subtaskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 47 DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;

ALTER TABLE
  `task_base`.`task_list`
ADD
  COLUMN `sourceDesc` VARCHAR(45) NULL
AFTER
  `taskSource`;

ALTER TABLE
  `task_base`.`task_list`
ADD
  COLUMN `delayTimes` INT ZEROFILL NULL
AFTER
  `sourceDesc`;

ALTER TABLE
  `task_base`.`subtask_list`
ADD
  COLUMN `delayTimes` INT ZEROFILL NULL
AFTER
  `delayReason`;

ALTER TABLE
  `task_supervise_schema`.`task_list`
ADD
  COLUMN `isFocus` INT NULL
AFTER
  `statusWeight`;

ALTER TABLE
  `task_supervise_schema`.`task_list`
ADD
  COLUMN `focusBy` VARCHAR(300) NULL
AFTER
  `isFocus`;

ALTER TABLE
  `task_base`.`task_list`
ADD
  COLUMN `focusBy` VARCHAR(45) NULL
AFTER
  `statusWeight`;

ALTER TABLE
  `task_supervise_schema`.`task_list`
ADD
  COLUMN `leadComment` VARCHAR(700) NULL
AFTER
  `focusBy`;

CREATE TABLE `task_base`.`comment_list` (
  `commentId` INT NOT NULL AUTO_INCREMENT,
  `taskId` INT NULL,
  `comment` VARCHAR(200) NULL,
  `username` VARCHAR(45) NULL,
  `createTime` DATETIME NULL,
  PRIMARY KEY (`commentId`)
);

SELECT
  *
FROM
  task_supervise_schema.task_list;

ALTER TABLE
  `task_base`.`task_list`
ADD
  COLUMN `checkAuth` VARCHAR(45) NULL
AFTER
  `leadComment`;