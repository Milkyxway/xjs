CREATE TABLE `comment_list` (
    `commentId` int(11) NOT NULL AUTO_INCREMENT,
    `taskId` int(11) DEFAULT NULL,
    `comment` varchar(200) DEFAULT NULL,
    `username` varchar(45) DEFAULT NULL,
    `createTime` datetime DEFAULT NULL,
    PRIMARY KEY (`commentId`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8mb4;

CREATE TABLE `subtask_list` (
    `parentId` int(11) DEFAULT NULL,
    `subtaskId` int(11) NOT NULL AUTO_INCREMENT,
    `taskContent` varchar(45) DEFAULT NULL,
    `finishTime` datetime DEFAULT NULL,
    `taskGoal` varchar(300) DEFAULT NULL,
    `status` int(11) DEFAULT NULL,
    `updateTime` datetime DEFAULT NULL,
    `createTime` datetime DEFAULT NULL,
    `leadOrg` int(11) DEFAULT NULL,
    `comment` varchar(45) DEFAULT NULL,
    `completeDesc` varchar(800) DEFAULT NULL,
    `actualFinish` datetime DEFAULT NULL,
    `delayReason` varchar(45) DEFAULT NULL,
    `delayTimes` int(10) unsigned zerofill DEFAULT NULL,
    `statusWeight` int(11) DEFAULT NULL,
    PRIMARY KEY (`subtaskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 294 DEFAULT CHARSET = utf8;

CREATE TABLE `task_list` (
    `taskId` int(11) NOT NULL AUTO_INCREMENT,
    `taskContent` varchar(400) DEFAULT NULL,
    `taskGoal` varchar(300) DEFAULT NULL,
    `status` int(11) DEFAULT NULL,
    `category` int(11) DEFAULT NULL,
    `comment` varchar(300) DEFAULT NULL,
    `leadOrg` int(11) DEFAULT NULL,
    `assistOrg` varchar(100) DEFAULT NULL,
    `createTime` datetime DEFAULT NULL,
    `children` int(11) DEFAULT NULL,
    `updateTime` datetime DEFAULT NULL,
    `hasChildren` tinyint(4) DEFAULT NULL,
    `resolveType` varchar(45) DEFAULT NULL,
    `finishTime` datetime DEFAULT NULL,
    `ariseOrg` int(11) DEFAULT NULL,
    `actualFinish` datetime DEFAULT NULL,
    `completeDesc` varchar(2000) DEFAULT NULL,
    `delayReason` varchar(45) DEFAULT NULL,
    `taskSource` int(11) DEFAULT NULL,
    `sourceDesc` varchar(45) DEFAULT NULL,
    `delayTimes` int(10) unsigned zerofill DEFAULT NULL,
    `statusWeight` int(11) DEFAULT NULL,
    `focusBy` varchar(45) DEFAULT NULL,
    `leadComment` varchar(700) DEFAULT NULL,
    `checkAuth` varchar(45) DEFAULT NULL,
    `taskRegion` varchar(45) DEFAULT NULL,
    PRIMARY KEY (`taskId`)
) ENGINE = InnoDB AUTO_INCREMENT = 332 DEFAULT CHARSET = utf8;

CREATE TABLE `user` (
    `username` varchar(16) NOT NULL,
    `password` varchar(32) NOT NULL,
    `userId` int(11) NOT NULL AUTO_INCREMENT,
    `role` varchar(45) DEFAULT NULL,
    `orgnization` int(11) DEFAULT NULL,
    `usernameCn` varchar(45) DEFAULT NULL,
    `region` varchar(45) DEFAULT NULL,
    PRIMARY KEY (`userId`)
) ENGINE = InnoDB AUTO_INCREMENT = 51 DEFAULT CHARSET = utf8;