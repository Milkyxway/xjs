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
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


UPDATE task_base.task_list  SET completeDesc = '在“迎春杯”和“春雷行动”的活动政策中均有体现。' WHERE taskId = 108 
UPDATE task_base.task_list  SET completeDesc = 'FTTH小区的专项已经制定下发。' WHERE taskId = 109
UPDATE task_base.task_list  SET completeDesc = '已完成，4月份政企部提供政企全业务素材至市场部。' WHERE taskId = 110
UPDATE task_base.task_list  SET completeDesc = '已经完成全年宣传计划编制，并在按计划持续进行中。市场运营部围绕全市宣传重点制定了产品宣传计划，目前正在按计划推进，本地电视台、电台、公司自有媒体等渠道均完成了投放，产品知晓度有了一定提升。一季度，部分商业综合体地库、小区门禁广告陆续开始投放，4月份即将开始小区道闸广告的投放，以增强产品宣传的立体化传播效果。但是由于现今信息的分散性，广告宣传效果会有一定滞后。并且，品牌建设是一个长期的过程，我们广告宣传的预算也有额度，投入过大，会对公司的经营产生影响，所以公司及产品的宣传也需要一线人员共同加入，大家一起对公司和产品进行宣传。' WHERE taskId = 111
UPDATE task_base.task_list  SET completeDesc = '经研究，按照智慧广电乡村工程长效运营要求，第二年，第三年在原有工程基础上有新业态发展及点击率，曝光率有显著增加的地区，参照第一年奖励比例提高。' WHERE taskId = 112
UPDATE task_base.task_list  SET completeDesc = '陆续推出合约机套餐：针对高端市场，推出苹果常态化合约机套餐；针对农村市场、银发市场，推出一体化合约机套餐；针对各阶层人群，以手机为主，包括各泛终端在内的相关产品，推出安卓常态化合约机套餐。' WHERE taskId = 113
UPDATE task_base.task_list  SET completeDesc = '企业发展部可牵头协调编制可研中的专业数据等内容。已完成。' WHERE taskId = 114
UPDATE task_base.task_list  SET completeDesc = '考核指标计分已调整，取消原规模因素系数，原因1.分解指标中已包含人均因素；2.销账奖励中已充分体现大站优势。' WHERE taskId = 115
UPDATE task_base.task_list  SET completeDesc = '现已经出台千兆宽带政策，并根据省公司的价格体系和对标无锡宽带市场其它运营商价格体系制定了无锡分公司的宽带价格体系。现基本互动用户的宽带主要从100M起，为后期营销已预留出空间。' WHERE taskId = 116
UPDATE task_base.task_list  SET completeDesc = '高清升级是省政府对于省公司的要求，也是省公司给分公司下达的考核指标，同时也是后期业务发展的基础。' WHERE taskId = 117
UPDATE task_base.task_list  SET completeDesc = '现有的体验政策都有后续订购策略。' WHERE taskId = 118
UPDATE task_base.task_list  SET completeDesc = '目前利用各种新媒体手段和渠道制作了各种宣传视频，希望一线同事能积极转发、宣传。' WHERE taskId = 119
UPDATE task_base.task_list  SET completeDesc = '无锡各镇（街道）与各广电站对口联络，已结合先前及目前对接情况梳理完毕，同时各镇（街道）与多个广电站有交集的，已与各站沟通确定，并已将名单发至各站。后期行政区划调整的，各涉及站协商后作相应调整。' WHERE taskId = 120


UPDATE `task_base`.`task_list` SET status = 6 WHERE taskId = 144;
UPDATE `task_base`.`task_list` SET status = 6 WHERE taskId = 143;
UPDATE `task_base`.`task_list` SET status = 6 WHERE taskId = 140;
UPDATE `task_base`.`task_list` SET status = 6 WHERE taskId = 135;