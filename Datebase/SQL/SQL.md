# 1、基础教程

## 1.1 一些小知识点

SQL 语言具有两种使用方式，分别称为交互式SQL和嵌入式 SQL。

在MySQL中，如果我们**删除了表中的大量数据**，或者我们对**含有可变长度文本数据类型**(VARCHAR，TEXT或BLOB)的表进行了很多更改，不过被删除的数据记录仍然被保持在MySQL的**链接清单**中，因此数据存储文件的大小并不会随着数据的删除而减小。

对MySQL进行**碎片整理的**方法非常简单，因为MySQL已经给我们提供了对应的SQL指令，这个SQL指令就是OPTIMIZE TABLE

管理MYSQL服务器程序

1. 通过windows提供的服务：cmd.exe；services.msc 
2. 命令行的操作：Net stop 服务名；net start MYSQL



可以把 SQL 分为两个部分：**数据操作语言(DML) 和数据定义语言 (DDL)。**

**DML**

> SQL (结构化查询语言)是用于执行查询的语法。但是 SQL 语言也包含用于更新、插入和删除记录的语法。
>

查询和更新指令构成了 SQL 的 **DML** **部分**：

- SELECT - 从数据库表中获取数据

  SELECT 列名称 FROM 表名称

  SELECT * FROM 表名称

- UPDATE - 更新数据库表中的数据
- DELETE - 从数据库表中删除数据
- INSERT INTO - 向数据库表中插入数据

 

**DDL**

> SQL 的数据定义语言 (DDL) 部分使我们有能力创建或删除表格。
>
> 我们也可以定义索引（键），规定表之间的链接，以及施加表间的约束。
>

SQL 中最重要的 DDL 语句:

- CREATE DATABASE - 创建新数据库
- ALTER DATABASE - 修改数据库
- CREATE TABLE - 创建新表
- ALTER TABLE - 变更（改变）数据库表
- DROP TABLE - 删除表
- CREATE INDEX - 创建索引（搜索键）
- DROP INDEX - 删除索引

 

**DCL** （Data Control Language）：

> 是数据库控制功能。是用来设置或更改数据库用户或角色权限的语句，包括（grant,deny,revoke等）语句。在默认状态下，只有sysadmin,dbcreator,db_owner或db_securityadmin等人员才有权力执行DCL  
>

MySQL 的账户信息保存在 mysql 这个数据库中。

**创建账户**

新创建的账户没有任何权限。

```sql
CREATE USER myuser IDENTIFIED BY 'mypassword';
```

**修改账户名**

```sql
RENAME myuser TO newuser;
```

**删除账户**

```sql
DROP USER myuser;
```

**查看权限**

```sql
SHOW GRANTS FOR myuser;
```

**授予权限**

账户用 username@host 的形式定义，username@% 使用的是默认主机名。

```sql
GRANT SELECT, INSERT ON mydatabase.* TO myuser;
```

**删除权限**

GRANT 和 REVOKE 可在几个层次上控制访问权限：

- 整个服务器，使用 GRANT ALL 和 REVOKE ALL；

- 整个数据库，使用 ON database.*；

- 特定的表，使用 ON database.table；

- 特定的列；

- 特定的存储过程。


```sql
REVOKE SELECT, INSERT ON mydatabase.* FROM myuser;
```

**更改密码**

必须使用 Password() 函数

```sql
SET PASSWROD FOR myuser = Password('new_password');
```

**权限传递**

with grant option

使用这个子句时将允许用户将其权限分配给他人



**DQL**（ Data Query Language） 

> 数据查询语言，数据查询语言DQL基本结构是由SELECT子句，FROM子句，WHERE



**记录操作总结**

综合查询相关关键字：select，from，where，group by，having，order by；它们的执行顺序是如下：

- from：首先执行from，找到要查询表；
- where：判断条件；
- group by：根据以上关键字执行的结果上对记录按照指定列进行分组； 
- **having：对分组后的信息进行筛选；**
- select：选择所需要的列信息；
- order by：对查询信息进行排序。

Where之后，考察的是<>不会记录null

## 1.2 数据库的操作

**创建数据库: Create database db_name [数据库选项];标识符(数据库名)命名规则**

创建一个使用utf-8字符集，并带校对规则的mydb3数据库。

create database mydb1 character set utf8 collate utf8_general_ci;

在mysql的data目录，形成一个目录，目录名是数据库名。

如果是特殊字符的数据库名,则文件夹名则使用编码的形式，目录内,存在一个文件,用于保存数据库的选项信息。**Db.opt** 

1. 查看当前存在的数据库:

   Show databases; 

2. 显示库的创建信息

   show create database db_name;

3. 删除前面创建的mydb1数据库

   drop database mydb1;

4. 修改数据库信息

   alter database db_name [修改指令]

   指令:数据库属性的修改。

5. 查看当前数据库的字符集**

   mysql> show variables like "%charac%";

### 1.2.1 数据备份与还原

> **备份**：将当前已有的数据或记录保留。原始数据面临的问题：持续改变；
>
> **还原**：将已经保留的数据恢复到对应的表。仅能恢复至备份操作时刻的数据状态；

数据备份还原的方式有很多种：数据表备份，单表数据备份，sql备份，增量备份。

**按照备份的数据完整性分为：全量备份、增量备份、差异备份**

- 全量备份：完全备份所有数据；
- 增量备份：仅备份自上一次完全备份或增量备份以来变量的那部数据；
- 差异备份：仅备份自上一次完全备份以来变量的那部数据；

**按照备份方式分为：物理备份、逻辑备份**

- 物理备份：效率高，复制数据文件进行的备份；
- 逻辑备份：从数据库导出数据另存在一个或多个文件中； 

**根据数据服务是否在线分为：**

- 热备：读写操作均可进行的状态下所做的备份，MyISAM不支持，innodb支持；
- 温备：可读但不可写状态下进行的备份；
- 冷备：读写操作均不可进行的状态下所做的备份；

**备份策略：**

全量+差异 + binlogs二进制日志时间点还原
全量+增量 + binlogs二进制日志时间点还原 

**备份内容**

- 数据、二进制日志、InnoDB的事务日志，尽量分开存放；
- 代码（存储过程、存储函数、触发器、事件调度器）
- 服务器的配置文件

#### 数据表备份

- 不需要通过sql来备份，直接进入到数据库文件夹复制对应的表结构以及数据文件，以后还原的时候，直接将备份的内容放进去即可。


- 数据表备份的前提条件：根据不同的存储引擎有不同的区别。存储引擎：mysq进行数据存储的方式：innodb和myisam（免费）


- 对比myisam和innodb的数据存储方式

  innodb：只有表结构，数据全部存储到ibdata1文件中

  myisam：**表**，**数据**和**索引**分成单独存储

#### 单表数据备份

- 每次只能备份一张表，只能备份数据（表结构不能备份）


- 通常的使用：将表中的数据进行导出到文件


- 备份：从表中选出一部分数据保存到外部的文件中（outfile）


```sql
Select * 字段列表 into outfile ‘文件所在的路径’from 数据源; --前提：外部文件不存在。
```

- 高级备份：自己制定字段和行的处理方式


```sql
Select  * 字段列表 into outfile  ‘文件所在的路径’fields字段处理 lines 行处理 from数据源;
```

| Fields：字段处理 |                                                  |
| ---------------- | ------------------------------------------------ |
| Enclosed by      | 字段使用什么内容包裹，默认是’’（空字符串）       |
| Terminated by    | 字段以什么结束，默认是”\t”（tab键）              |
| Escaped by       | 特殊符号用什么方式处理，默认是‘\\’（反斜杠转义） |
| Starting by      | 每行以什么开始，默认是’’（空字符串）             |
| Terminated by    | 每行以什么结束，默认是”\r\n”（换行符）           |

- 数据还原：将一个在外部的数据重新恢复到表中（如果表结构部不存在，那么sorry）。

  ```sql
  Load data infile文件所在路径 into table表名[字段列表] fields字段处理 lines行处理;  --怎么备份的怎么
  ```

#### sql备份

> 备份的是sql语句：系统会对表结构以及数据进行处理，变成对应的sql语句，然后进行备份。还原的时候只有执行sql指令即可（主要是针对表结构）。
>

- 备份：mysql没有提供备份指令，需要利用mysql提供的软件：mysqldump.exe。Mysqldump.exe也是一种客户端，需要操作服务器，必须连接认证

- 基本语法：备份命令 mysqldump 格式

  mysqldump -h 主机名 -P 端口 -u 用户名 -p密码 –database 数据库名 > 文件名.sql 

- 代码：表备份

  mysqldump -uroot -p  mydatabase my_student > D:\server\student.sql

- 代码：库备份

  mysqldump -uroot -p mydatabase  > D:\server\mydatabase.sql

**sql还原数据：两种方式还原**

- 使用mysql.exe 客户端还原

  mysql -uroot -p mydatabase < D:\server\mydatabase.sql

- 使用sql指令还原

  Source 备份所在的目录

  source D:\server\student.sql;

**sql备份优缺点：**优点：可以备份结构；缺点：会浪费空间（额外增加sql指令）

#### 增量备份

指定时间段进行备份，备份数据不会重复，而且所有的操作都会备份（大项目都用增量备份）

## 1.3 创建表与约束

### 1.3.1 默认的字符集与校对

```sql
create table 表名(
    字段1 类型，
    字段2 类型，
     .....
) character set utf8 collate utf8_general_ci; 
```

1. 可以通过. 语法,指明数据表所属的数据库

   库.表：database.table

   如果任何的标识符，出现的殊字符，需要使用反引号包裹。

2. 进行表操作时,可以先指定当前的默认数据库:

   Use db_name；**只是设定了默认数据库**，不会影响操作其他数据库

3. 为了区分相同逻辑表名的不同应用，给逻辑表名增加前缀，形成真实表名。

### 1.3.2 约束

注意:数据库中一共有六种约束，而mysql只支持五种

约束用于限制加入表的数据的类型。

可以在创建表时规定约束（**通过** **CREATE TABLE** **语句**），或者在表创建之后也可以（**通过** **ALTER TABLE** **语句**）。

我们将主要探讨以下几种约束：

- **NOT NULL**
- **UNIQUE**
- **PRIMARY KEY**
- **FOREIGN KEY**
- **CHECK**
- **DEFAULT**
- **auto_increment**

#### NOT NULL 约束

NOT NULL 约束强制列不接受 NULL 值。

NOT NULL 约束**强制字段始终包含值**。这意味着，如果不向字段添加值，就无法插入新记录或者更新记录。

#### UNIQUE 约束

UNIQUE 约束**唯一标识数据库表中的每条记录。**

UNIQUE 和 PRIMARY KEY 约束均为列或列集合提供了唯一性的保证。

**PRIMARY KEY拥有自动定义的 UNIQUE约束。**

请注意，每个表可以有多个 UNIQUE 约束，**但是每个表只能有一个PRIMARY KEY约束。**

 

1. 一张表往往需要多个字段具有唯一性（数据不能重复），但是一张表中只能有一个主键。唯一键可解决表中多个字段需要唯一性约束的问题。

2. 唯一键的本质和主键差不多，**唯一键默认允许自动为空，而且多个为空（空字段不参与唯一性比较）。**

3. 增加唯一键

   方案1：在创建表的时候，字段后直接跟unique/unique key。

   方案2：在所有的字段后增加unique key（字段列表）；复合唯一键

   方案3：在创建表后增加唯一键。

   ```sql
   alter table my_unique3 add unique key(number);
   ```

4. 更新唯一键&删除唯一键

   更新唯一键：先删除后新增（唯一键可以有多个，可以不删除）

   删除唯一键：

   ```sql
   Alter table 表名 drop index 索引名字; -- 唯一键默认使用字段名作为索引名字
   ```

#### PRIMARY KEY 约束

PRIMARY KEY 约束唯一标识数据库表中的每条记录。

主键必须包含唯一的值，主键列不能包含 NULL 值，每个表都应该有一个主键，并且每个表只能有一个主键。

- 增加主键

方案1：在创建表的时候，直接在字段之后跟primary key关键字（主键本身不允许为空）

```sql
-- 增加主键
create table my_pril(
name varchar(20) not null comment '学生姓名',
number char(10) primary key comment '学生学号，itcast+0000'
)charset utf8;
```

方案2：在创建表的时候，在所有字段之后，使用primary key（主键列表）来创建主键（如果有多个字段作为主键，则为**复合主键**）

```sql
-- 复合主键
create table my_pri2(
number char(10) comment'学号：itcast+0000',
course char(8)  comment'课程代码：3901+0000',
score tinyint unsigned default 60 comment'成绩',
-- 增加主键
primary key(number,course)
)charset utf8;
```

效果：

 ![image-20200720102412856](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720102412856.png)

方案3：当表已经创建好了之后，再次额外追加主键。可以通过修改字段属性，也可以直接追加：alter table 表名 add primary key（字段列表）;

```sql
-- 追加主键测试
-- 创建没有主键的表
create table my_pri3(
course char(8) not null comment'课程编号：3901+0000',
name varchar(10) not null comment'课程名字'
)charset utf8;
-- 查看表
desc my_pri3;
-- 追加主键
alter table my_pri3 add primary key(course);
-- 查看表
desc my_pri3;
```

- **主键约束**

主键对应的字段中的数据不允许重复。一旦重复，则数据插入失败。

- **主键更新&删除主键**

**没有办法更新主键**，主键必须先删除，才能增加。

```sql
Alter table 表名 drop primary key;
 -- 追加主键
alter table my_pri3 add primary key(course);
```

- **主键分类**

在实际创建表的过程中，很少使用**真实的业务数据**作为主键字段（业务主键，如学号，课程号）。大部分的时候使用**逻辑性的字段**（字段没有业务含义，值是什么都没有关系），将这种字段主键称为逻辑主键。

```sql
-- 使用逻辑型字段作为主键
create table my_student(
Id int primary key auto_increment comment'逻辑主键：自增长',
Number char(10) not null comment'学号',
name varchar(10) not null
)charset utf8
```

#### auto_increment约束

**当相应字段为默认值或Null，自增长会自动被系统触发。**系统会从当前字段中已有的最大值再进行+1操作，得到一个新的不同的字段。

```sql
insert into my_auto (name) values('邓丽君');
insert into my_auto values(null,'baby');
insert into my_auto values(default,'汪涵') 
```

![image-20200721151807212](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721151807212.png)

1. 任何一个字段要做自增长，**本身必须是一个索引(key)。**
2. 自增长字段必须是数字（整型）。
3. **一张表最多只能有一个自增长。**

**修改自增长**

1. 自增长涉及到字段改变，必须先删除自增长，后增加（一张表只能有一个自增长）。修改当前自增长已经存在的值（修改的值必须比当前自增长最大值还要大）。**Alter table 表名 auto_increment =值;**

   <img src="C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721152055598.png" alt="image-20200721152055598" style="zoom:80%;" />

2. 思考：为什么自增长是从1开始且每次自增1？所有系统的实现（如字符集，校对集）都是有系统内部的变量进行控制的。

   查看自增长对应的变量：show variables like ‘auto_increment%’;

   ![image-20200720102954597](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720102954597.png)

**删除自增长**

自增长是字段的一个属性：可以通过modify来进行修改（保证字段没有auto_increment即可）Alter table 表名 modify 字段 类型;

#### FOREIGN KEY 约束

一个表中的 FOREIGN KEY 指向另一个表中的 PRIMARY KEY。

**表的外键是另一表的主键 , 外键可以有重复的 , 可以是空值**

让我们通过一个例子来解释外键。请看下面两个表：

"Persons" 表：

| **Id_P** | **LastName** | **FirstName** | **Address**     | **City**  |
| -------- | ------------ | ------------- | --------------- | --------- |
| 1        | Adams        | John          | Oxford  Street  | London    |
| 2        | Bush         | George        | Fifth  Avenue   | New  York |
| 3        | Carter       | Thomas        | Changan  Street | Beijing   |

"Orders" 表：

| **Id_O** | **OrderNo** | **Id_P** |
| -------- | ----------- | -------- |
| 1        | 77895       | 3        |
| 2        | 44678       | 3        |
| 3        | 22456       | 1        |
| 4        | 24562       | 1        |

"Orders" 中的 "Id_P" 列指向 "Persons" 表中的 "Id_P" 列。
"Persons" 表中的 "Id_P" 列是 "Persons" 表中的 PRIMARY KEY。
"Orders" 表中的 "Id_P" 列是 "Orders" 表中的 FOREIGN KEY。

FOREIGN KEY 约束用于预防破坏表之间连接的动作。FOREIGN KEY 约束也能防止非法数据插入外键列，因为它必须是它指向的那个表中的值之一。

constraint Id_P _FK foreign key(Id_P) references teacher(Id_P)；

#### check约束

**就是给一列的数据进行了限制，CHECK** **约束用于限制列中的值的范围。**

**alter table** **表名称 add constraint** **约束名称** **增加的约束类型** **（列名）**

比方说，年龄列的数据都要大于20的

**alter table emp add constraint xxx check(age>20)**

 

如果对单个列定义 CHECK 约束，那么该列只允许特定的值。

如果对一个表定义 CHECK 约束，那么此约束会在特定的列中对值进行限制。

SQL CHECK Constraint on CREATE TABLE

下面的 SQL 在 "Persons" 表创建时为 "Id_P" 列创建 CHECK 约束。CHECK 约束规定 "Id_P" 列必须只包含大于 0 的整数。

```sql
CREATE TABLE Persons
(
Id_P int NOT NULL,
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Address varchar(255),
City varchar(255),
CHECK (Id_P>0)
)
```

如果需要命名 CHECK 约束，以及为多个列定义 CHECK 约束，请使用下面的 SQL 语法：

CONSTRAINT chk_Person CHECK (Id_P>0 AND City='Sandnes')

#### default 约束：

意思很简单就是让此列的数据默认为一定的数据

alter table 表名称 add constraint 约束名称 约束类型 默认值 for 列名

比方说：emp表中的gongzi列默认为10000

```sql
alter table emp add constraint jfsd default 10000 for gongzi
```

### 1.3.3 DISTINCT

相同值只会出现一次。

如果它作用于所有列，也就是说所有列的值都相同才算相同。

### 1.3.4 列描述comment

没有实际含义，专门用来描述字段，会根据表创建语句保存。用来给程序员（数据库管理员）来进行了解的。

show create table 表名;

### 1.3.5 蠕虫复制

1. 从已有的数据中获取数据，然后将数据进行新增操作（数据成倍增加）

   表创建高级操作：从已有表创建新表（复制表结构）。

   **create table my_copy like my_student;**

   ![image-20200720103233065](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103233065.png)

2. 蠕虫复制：先查出数据，然后将查出的数据新增一遍。**

   **Insert into** **表名 [(****字段列表)] select** **字段列表/\* from** **数据表名;**

3. 蠕虫复制意义：

   从已有的表拷贝数据到新表

   可以迅速让表中的数据膨胀到一定的数量级：测试表的压力以及效率

### 1.3.6 外键

外键（foreign key）：外面的键（键不在自己表中），如果一张表中有一个字段（非主键）指向另外一张表的主键，**那么将该字段称为外键。**

- 增加外键

  外键可以在创建表的时候或者创建表之后增加（但是要考虑数据问题）。

  一张表可以有多个外键

1）创建表的时候增加外键：在所有的表字段语句之后，使用foreign key（外键字段） references外部表（主键字段）

```sql
--创建外键
create table my_foreign1(
id int primary key auto_increment,
name varchar(20) not null comment'学生姓名',
c_id int comment '班级id',
--增加外键
foreign key(c_id) references my_class(id)
)charset utf8;
```

 ![image-20200720103256253](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103256253.png)

2）在新增表之后增加外键，修改表结构。

Alter table 表名 add [constraint 外键名字] foreign key（外键字段）references  父表（主键字段）

```sql
--增加外键
alter table my_foreign2 **add**
--指定外键名
constraint student_class_1
--指定外键字段
foreign key(c_id)
--引用父表
references my_class(id);
```

- 修改外键&删除外键（外键不可修改，只能先删除后新增。）

删除外键的语法：

Alter table 表名 drop foreign key  外键名;

```sql
--查看表结构
desc my_foreign1;
--删除外键
alter table my_foreign1 drop foreign key my_foreign1_ibfk_1;
--查看表结构
desc my_foreign1;
--查看表创建语句
show create table my_foreign1;
```

![image-20200720103309432](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103309432.png)

- 外键作用

**对字表的约束：**子表数据进行写操作（增和改）的时候，如果对应的外键字段在父表中找不到对应的匹配，那么操作会失败（约束子表数据操作）。外键有值，外键对应的表无数据则不能插入。

insert into my_foreign2 values(null,'张飞',5);

![image-20200720103318579](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103318579.png)

**对父表的约束：**父表数据进行写操作（删除和修改），如果对应的主键在子表中已经被数据引用，那就不允许操作。

- 外键条件


1. 外键要存在，首先必须保证表的**存储引擎是innodb**（默认存储引擎）；如果不是innodb存储引擎，那么外键可以创建成功，但是没有约束效果。
2. 外键字段的字段类型（列类型）与父表的主键**类型完全一致**。
3. 一张表中**外键名字不能重复**。
4. 增加外键的字段（数据已经存在），必须保证数据

 

- 外键约束


1. 所谓外键约束：就是**指外键的作用**

2. 之前所讲的外键作用：是默认的作用，其实可以通过对外键的需求，进行定制。

3. 外键约束有三种约束模式，都是针对父表的约束。

   district：严格模式（默认的），父表不能删除或者更新一个已经被字表数据引用的记录

   cascade：级联模式，**父表的操作对字表关联的数据也跟着被删除。**

   setnull：置空模式，父表的操作之后，字表对应的数据（外键字段）被置空。

   通常的一个合理做法（约束模式）：**删除的时候字表置空，更新的时候子表级联操作指定模式的语法。**

   指定模式的语法：Foreign key(外键字段) references父表（主键字段）on delete set null on update cascade;

   ```sql
   --创建外键：指定模式（删除置空，更新级联）
   create table my_foreign3(
   id int primary key auto_increment,
   name varchar(20) not null,
   c_id int,
   --增加外键
   foreign key(c_id)
   --引用表
   references my_class(id)
   --指定删除默认，更新级联
   on delete set null
   on update cascade
   )charset utf8;
   
   ```

   删除置空的前提条件：外键字段允许为空（如果不满足条件，外键无法创建）

## 1.4 数据表操作

### 1.4.1 查看表

1. 查看表结构

   Desc/describe/show columns from 表名；

2. 查看当前数据库下所有表

   show tables[like ‘pattern’]; 
   
   %：表示匹配多个字符；
   
    _：表示匹配单个字符； 

![image-20200720103337949](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103337949.png)

3. 查看表的字符编码集

   show create table 表名;

4. 删除表

   drop table [if exists] tbl_name;

### 1.4.2 修改表

1. **修改表的结构语法**格式:alter table 表 [add|drop|change|modify] ….;                 

​    关键字有以下几个:

​        1.add----添加列操作  alter table 表名 add 列名 类型;

​        alter table employee add image blob;

​        2.modify--修改列的类型 alter table 表名 modify 列名 类型;

​        alter table employee modify job varchar(60);

​        3.drop --删除列 alter table 表名 drop **COLUMN** 列名.

​		alter table employee drop COLUMN gender;

​        4.change--修改列名称 alter table 表名 change 旧列名 新列名 类型;

​        alter table user change name username varchar(20);

2. 修改表的名称

   rename table 旧表名 to 新表名;   

   rename table employee to user;

3. 修改表的字符编码集

   alter table 表名 character set 字符集;

   alter table user character set gb2312;

   支持，跨数据库重命名，此时当前表即被剪切过去而不再存在于当前数据库中!

### 1.4.3 表记录操作

#### WHERE 

where原理：where是唯一一个直接从磁盘获取数据的时候就开始判断的条件。从磁盘取出一条记录，开始进行where判断，判断的结果如果成立就保存到内存；如果失败就直接放弃。

```sql
SELECT 列名称 FROM 表名称 WHERE 列 运算符 值
```

SQL 使用**单引号来环绕文本值**（大部分数据库系统也接受双引号）。如果是数值，请不要使用引号。

**操作符：**

=   等于 ； <  小于  ； >  大于  ； <> != 不等于；<=  小于等于；>=   大于等；于**BETWEEN** **在两个值之间**；IS NULL为 NULL 值

**between是闭区间**

 

应该注意到，NULL 与 0、空字符串都不同。

- **AND** **和 OR** 用于连接多个过滤条件。优先处理 AND，当一个过滤表达式涉及到多个 AND 和 OR 时，可以使用 () 来决定优先级，使得优先级关系更清晰。
- IN 操作符用于**匹配一组值**，其后也可以接一个 SELECT 子句，从而匹配子查询得到的一组值。

- NOT 操作符用于否定一个条件。


#### group by

> Group by是分组的意思，根据某个字段进行分组（相同的放在一组，不同的分到不同的组）。
>

语法：group by 字段名;

分组的意义：是为了统计数据（按组统计：按分组字段进行数据统计）

Sql提供了一系列统计合计函数

- count()：统计分组后的记录数（每组分别有多少记录）
- Max()：统计每组中的最大值

- Min()：统计最小值

- Avg()：统计平均值
- Sum()：统计和

分组会自动排序：根据分组字段，默认升序

```sql
Group by 字段 [asc|desc]; -- 对分组的结果进行排序
```

多字段分组：先根据一个字段分组，然后对分组后的结果再次按照其他字段进行分组。

Group_concat(字段)：对分组的结果中的某个字段进行字符串连接（保留该组所有的某个字段）。

#### select

SQL的执行顺序：

- 第一步：执行FROM
- 第二步：WHERE条件过滤
- 第三步：GROUP BY分组
- 第四步：执行SELECT投影列
- 第五步：HAVING条件过滤
- 第六步：执行ORDER BY 排序

 **select的数据行数保持一致；**

1. 查询一张表： select * from 表名；

2. 查询指定字段：select 字段1，字段2，字段3....from 表名；

3. where条件查询：select 字段1，字段2，字段3 frome 表名 where 条件表达式；

   例：select * from t_studect where id=1; select * from t_student where age>22;

4. 带in关键字查询：select 字段1，字段2 frome 表名 where 字段 [not]in(元素1，元素2)；

   例：select * from t_student where age in (21,23);

   select * from t_student where age not in (21,23);

5. 带between and的范围查询：select 字段1，字段2 frome 表名 where 字段 [not]between 取值1 and 取值2；

   例：select * frome t_student where age between 21 and 29;

   select * frome t_student where age not between 21 and 29;

6. 带like的模糊查询：select 字段1，字段2... frome 表名 where 字段 [not] like '字符串'；“%”代表任意字符；“_"代表单个字符；

   例：select * frome t_student where stuName like '张三''；

   select * frome t_student where stuName like '张三%''；

   select * frome t_student where stuName like '%张三%''；//含有张三的任意字符

   select * frome t_student where stuName like '张三_''

7. 空值查询：select 字段1，字段2...frome 表名 where 字段 is[not] null;

8. 带and的多条件查询；

   select 字段1，字段2...frome 表名 where 条件表达式1 and 条件表达式2 [and 条件表达式n]

   例：select * frome t_student where gradeName='一年级' and age=23；

9. 带or的多条件查询

   select 字段1，字段2...frome 表名 where 条件表达式1 or 条件表达式2 [or 条件表达式n]

   例：select * frome t_student where gradeName='一年级' or age=23；//或者，条件只要满足一个

10. distinct去重复查询：select distinct 字段名 from 表名；字段多，则都需要相同才去除  

11. 对查询结果排序order by：select 字段1，字段2...from 表名 order by 属性名 [asc|desc]

    例：select * frome t_student order by age desc；//降序，从大到小

    select * frome t_student order by age asc；//升序，asc默认可以不写

12. 分组查询group by：**group by 属性名 having 条件表达式**

    单独使用（毫无意义，不能单独使用）；

    **与group_concat()函数一起使用；**

    例：select gradeName,group_concat(stuName) from t_student group by gradeName;

    **与聚合函数一起使用**

    例：select gradeName,count(stuName) from t_student group by gradeName;

    **与having一起使用（显示输出的结果）**

    例：select gradeName,count(stuName) from t_student group by gradeName having count(stuName)>3;

    **与with rollup 一起使用（最后加入一个总和行）**

    例：select gradeName,group_concat(stuName) from t_student group by gradeName with rollup;

13. limit 分页查询：select 字段1，字段2，...from 表名 limit 初始位置，记录数；

    例子：select * from t_student limit 0,5；

14. 使用别名  

    使用as 别名可以给表中的字段，表设置别名，在查询的时候显示select name as 姓名,(english+chinese+math) as 总分 from student;

    select name 姓名,(english+chinese+math) 总分 from student;

15. 在查询中可以直接对列进行运算

    select * from student where (english+chinese+math)>200;

#### having

- Where是针对磁盘数据进行判断，有效数据进入内存后，进行分组操作，分组的结果需要having来处理。

- Having能做where能做的所有事情，但是where却不能坐having能做的很多事情。

- **分组统计的结果或者说统计函数都只能在having中使用**
- **Having能够使用字段别名，而where不能。** Where是从磁盘取数据，而别名是在字段进入内存后才会产生的。

#### ORDER BY 

> ORDER BY 语句用于根据指定的列对结果集进行排序。**默认升序**
>

**依赖校对集。**

**order by** 子句是select的最后的一个子句。

如果您希望按照降序对记录进行排序，可以使用 **DESC** **关键字**。

- **ASC** ：升序（默认）
- **DESC** ：降序

可以按多个列进行排序，并且为每个列指定不同的排序方式：

```sql
SELECT * FROM mytable ORDER BY col1 DESC, col2 ASC;
```

#### INSERT INTO 

```sql
INSERT INTO 表名称 VALUES (值1, 值2,....);
INSERT INTO Persons VALUES ('Gates', 'Bill', 'Xuanwumen 10', 'Beijing');
```

我们也可以指定所要插入数据的列：**构造符（）**

```sql
INSERT INTO table_name (列1, 列2,...) VALUES (值1, 值2,....)
INSERT INTO Persons (LastName, Address) VALUES ('Wilson', 'Champs-Elysees')
```

可以省略对列的指定，要求 values () 括号内，提供给了按照**列顺序**出现的所有字段的值。

```sql
-- 或者使用set语法。
Insert into tbl_name set field=value,…；
```

可以指定在**插入的值出现主键（或唯一索引）冲突时**，更新其他非主键列的信息。

```sql
Insert into tbl_name 值 on duplicate key update 字段=值, …;
-- 逻辑：插入（失败，主键冲突）--跟新
```

可以通过一个查询的结果，作为需要插入的值。

Insert into tbl_name select …;

**注意：**

1. 没有给出要插入的列，那么表示插入所有列；
2. 值的个数必须是该表的列的个数；
3. 值的顺序，必须与表创建时给出的列的顺序相同。

#### Update 

> Update 语句用于修改表中的数据。

- 下面语句会将指定字段的值全部修改

  update 表名 set 字段名称=值;update employee set salary=5000;

- 如果要修改多个字段

  update 表名 set 字段1名称=值 ,字段2名称=值,...;

-  多表更新（使用join语法）

  Update t1 join t2 on t1.x=t2.x set字段1名称=值 ,字段2名称=值where cond;

以上方式，进行修改，会将表中这个字段所有值都修改.在实际开发中，对于修改操作，都是有条件修改。

UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值条件；

```sql
update employee set salary=3000 where username='aaa';
```

#### DELETE 

**删除是不可逆的：谨慎删除**

```sql
DELETE FROM tbl_name  [WHERE where_definition]  [ORDER BY ...]  [LIMIT row_count]
```

**按照条件删除**

指定删除的最多记录数。Limit

可以通过排序条件删除。Order by + limit

 

DELETE 语句用于删除表中的行。

DELETE FROM 表名称 WHERE 列名称 = 值

```sql
delete from employee where username='小李子';
```

**支持多表删除，使用类似连接语法**。

```sql
Delete from 需要删除数据表1，表2 using 表连接操作 条件;
```

关于删除表与删除表数据区别:

1. 删除表 

   drop table 表名

2. 删除表中记录  

   delete from 表名

   delete from employee;

3. truncate table 表名

   truncate table employee;



delete 与truncate的区别?

1. delete是一行一行删除  truncate是将表结构销毁，在重新创建表结构。如果数据比较多，truncate的性能高。

   **truncate 重置auto_increment的值为1**。而delete不会

2. delete是dml语句，truncate是DDL语句是隐式提交。

   delete是受事务控制，可以回滚数据。truncate是不受事务控制. 不能回滚。 

## 1.5 中文数据问题

中文数据问题本质是字符集问题。

计算机只识别二进制：人类更多是识别符号，需要有个二进制与字符的对应关系（字符集）

客户端向服务器插入中文数据：没有成功

- 查看服务器的所有字符集：show character set;

- 查看服务器默认对我处理的字符集：

  ```sql
  Show variables like‘character_set%’ ;
  Character_set_client：服务器默认的客户端字符集
  Character_set_connection：连接层字符集
  Character_setdatabase：当前所在数据库的字符集
  Character_set_results：服务器默认的给外部数据的字符集
  ```

**表中出现乱码分析1：**

问题根源：客户端数据只能是GBK，而服务器认为是UTF8。

解决方案：改变服务器，默认的接收字符集为GBK。

```sql
set character_set_client = gbk;
```

**表中出现乱码分析2：**

查看数据，中文为乱码？

问题根源：数据来源是服务器，解析数据的是客户端（客户端只识别gbk），但是服务器给的数据是utf8

解决方案：修改服务器给客户端的数据字符集为GBK。

```sql
set character_set_results = gbk;
```

中文显示正常！

- 设置服务器对客户端字符集的认识可以使用快捷方式：

  set names 字符集

   注：修改Character_set_client，Character_set_connection和Character_set_results

- connection连接层：是字符集转变的中间者，如果统一了效率更高，不同意也没问题。


# 2、高级教程

## 2.1 数据类型

SQL中将数据类型分成了三大类：**数值类型**，**字符串类型**和**时间日期类型**

数据类型（data_type）规定了列可容纳何种数据类型。下面的表格包含了SQL中最常用的

### 2.1.1 数值类型

#### 整数型

Tinyint 迷你整型，使用1个字节存储，表示状态最多为256种。（常用）Smallint 小整型，使用2个字节存储，表示状态最多为65536种。
Mediuint 中整型，使用3个字节存储。
Int 标志整型，使用4个字节存储。（常用）
Bigint 大整型，使用8个字节存储

- 使用相应数据类型时，存储的值需在规定的范围内。

- SQL中的数值类型全部都是默认有符号：分正负，有时候需要使用无符号数据：需要给数据限定数据类型：int unsigned-- 无符号，从0开始

- 每个字段数据类型之后**括号中的数字**代表的是**显示宽度**。

- 显示宽度的意义：当数据显示宽度不够的时候，会自动让数据变成对应的显示宽度。通常需要搭配一个前导0来增加宽度，不改变值大小。Zerofill（零填充）会导致无符号数。

- 零填充的意义（显示宽度）：**保证数据格式**


#### 小数型

u 浮点型：小数点浮动，精度有限，而且会丢失精度。
Float：单精度，占用4个字节存储数据，精度范围大概7位左右。
Double：双精度，占用8个字节存储数据，精度范围大概为15为左右。

创建浮点数表：

- 直接float（表示没有小数部分）
- float(M,D) M代表总长度，D代表小数部分长度，整形长度  为（M-D）

- 插入的数据可以是小数，也可以是科学计数法。

- 整数部分不能超出长度，小数部分可以。（4舍5入）


u 定点型：小数点固定，精度固定，不会丢失精度。

绝对保证整数部分和不会被四舍五入（不会丢失精度），小数部分有可能（理论小数部分也不会丢失精度）。

#### 时间日期类型

 ![image-20200720103405977](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103405977.png)

### 2.1.2 字符串类型

#### 定长变长字符串varchar

在SQL中，将字符串类型分成了6类：char，vachar，text，blob，enum和set。

- Char[4]在utf8环境下，需要4*3=12个字节。

- Varchar(10)：若存了10个汉字，utf8环境下占用空间：10*3+1=31（但是会多出1到2个字节来确定存储的实际长度。）

- 如何选择定长或者变长字符串？

  定长的磁盘空间比较浪费，但是效率高。如果数据长度基本一样，就使用定长，如身份证，手机号码，电话号码等。变长的磁盘空间比较节省，但是效率低。如果不同数据长度有变化，如姓名，地址。

#### 文本字符串

如果数据量非常大（超过255）就会使用文本字符串。文本字符串根据储存的数据格式进行分类：text和blob

Text：储存文字（二进制数据实际上都是只存数据的储存路径）

Blob：储存二进制数据（通常不用）

#### 枚举字符串

#### 集合字符串

定义：set（元素列表）

gender enum(‘male’,’female’.’secret’)

使用：可以使用元素列表中的元素，使用逗号分隔。

集合中每一个元素都是对应一个二进制位，被选中为1，没有则为0.

### 2.1.3 Mysql记录长度

- Mysql规定：任何一条记录最长不能超过**65535**个字节（varchar永远达不到理论值）。

- Utf8下的varchar的实际顶配：21844（21844*3+2=65534）字符

- Gbk下的varchar的实际顶配：32766（32766*2+2=65534）字符

- Mysql记录中，如果有任何一个字段允许为空，那么系统会自动从整个记录中保留一个字节来存储NULL（若想释放Null所占用的字节，必须保证所有的字符都不允许为空）。

- Mysql中text文本字符串，不占用记录长度（额外存储），但是text文本字符串也是属于记录的一部分，一定需要占用记录中的部分长度（10个字符串）。


## 2.2 索引

> 索引：系统根据某种算法，将已有的数据（未来可能新增的数据），单独建立一个文件，文件能实现快速的数据匹配数据，并且能快速的找到对应表中的记录。
>

**增加索引的前提条件：**索引本身会产生索引文件（有时候可能比数据文件还大），会非常耗费磁盘空间；如果某个字段需要作为查询的条件经常使用，那么可以使用索引（一定会想办法增加）；如果某个字段需要进行数据的有效性约束，也可以使用索引（主键，唯一键）。

**mysql中提供了多种索引**

- 主键索引：primary key
- 唯一索引：unique key
- 全文索引：fulltext index；针对文字内部的关键字进行索引，全文索引的最大问题在于如何确定关键字

- 普通索引：index

**数据源**

数据来源，关系型数据库的来源都是数据表。本质上只要保证数据类似二维表，最终都可以作为数据源。

数据源分为多种：单表数据源，多表数据源，查询语句

- 单表数据源：select * from 表名;

- 多表数据源：select * from 表名1,表名2.....;


![image-20200720103427273](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200720103427273.png)

​		笛卡尔积没有意义，应尽量避免。

- **子查询：数据的来源是一条查询语句（查询语句的结果是二维表）**

  ```sql
  Select * from（select 语句）as 表名
  ```

### 2.2.1 CREATE INDEX 

您可以在表中创建索引，以便更加快速高效地查询数据。

用户无法看到索引，它们只能被用来加速搜索/查询。

**注释：**更新一个包含索引的表需要比更新一个没有索引的表更多的时间，这是由于索引本身也需要更新。因此，理想的做法是仅仅在**常常被搜索的列（以及表）上面创建索引**。

在表上创建一个简单的索引。允许使用重复的值：

```sql
CREATE INDEX index_name ON table_name (column_name);
-- 唯一的索引意味着两个行不能拥有相同的索引值。
CREATE UNIQUE INDEX index_name ON table_name (column_name)
```

**注释：**"column_name" 规定需要索引的列



本例会创建一个简单的索引，名为 "PersonIndex"，在 Person 表的 LastName 列：

```sql
CREATE INDEX PersonIndex ON Person (LastName) ;
```

如果您希望以**降序**索引某个列中的值，您可以在列名称之后添加保留字 **DESC**：

```sql
CREATE INDEX PersonIndex ON Person (LastName DESC) ;
```

假如您希望索引不止一个列，您可以在括号中列出这些列的名称，用逗号隔开：

```sql
CREATE INDEX PersonIndex ON Person (LastName, FirstName);
```

### 2.2.2 DROP INDEX 语句

**通过使用 DROP** **语句，可以轻松地删除索引、表和数据库。**

我们可以使用 DROP INDEX 命令删除表格中的索引。

```sql
ALTER TABLE table_name DROP INDEX index_name;
```

## 2.3 limit 子句

> Limit子句是一种限制结果的语句：限制数量
>

**Limit两种使用方式：**

1. 只用来限制长度（数据量）：limit数据量

   ```sql
   Select * from my_student limit 2;
   ```

   限制起始位置，限制数量：limit 起始位置，长度

   ```sql
   Select * from my_student 0,2 -- 从0开始，寻找两
   ```

2. 主要是用来实现数据的分页，为用户节省时间，提高服务器的响应效率，减少资源的浪费。

   对于用户来讲，可以点击分页按钮：1,2,3,4，对服务器来讲：根据用户选择的页码来获取不同的数据：limit offset，length

   Length：每页显示的数据量，基本不变

   Offset = （页码-1）*每页显示量

## 2.4 TOP 子句

> TOP 子句用于规定要返回的记录的数目。
>

对于拥有数千条记录的大型表来说，TOP 子句是非常有用的。

**注释：**并非所有的数据库系统都支持 TOP 子句。

```sql
-- 语法
SELECT TOP number|percent column_name(s) FROM 
-- 实例
table_name;SELECT TOP 2 * FROM Persons;
SELECT TOP 50 PERCENT * FROM Persons;
SELECT top 10 * FROM Table_Name ORDER BY ID DESC;
```

**MySQL和 Oracle中的 SQL SELECT TOP是等价的**

## 2.5 LIKE 操作符

**LIKE操作符用于在 WHERE子句中搜索列中的指定模式。**

```sql
SELECT column_name(s) FROM table_name WHERE column_name LIKE pattern;
```

**提示："%"** **可用于定义通配符（模式中缺少的字母）**

在搜索数据库中的数据时，SQL 通配符可以替代一个或多个字符。

**SQL** **通配符必须与 LIKE** **运算符一起使用**。

在 SQL 中，可使用以下通配符：

| **通配符**                     | **描述**                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| %                              | 替代一个或多个字符                                           |
| _                              | 仅替代一个字符                                               |
| [charlist]                     | 字符列中的任何单一字符  "Persons" **表中选取居住的城市**以 "A" 或 "L" 或 "N" 开头的人：LIKE '[ALN]%' |
| [^charlist]  或者  [!charlist] | 不在字符列中的任何单一字符  "Persons" 表中选取居住的城市*不以* "A"  或  "L" 或  "N" 开头的人：LIKE  '[!ALN]%' |

## 2.6 连接查询

> 连接查询：将多张表（大于2张）进行记录的连接（按照某个指定的条件进行数据拼接）。最终结果是记录数有可能变化，字段数一定会增加（至少两张表合并）。
>

连接查询的意义：在用户查看数据的时候，需要显示的数据来自多张表。



连接查询（join）使用方式：**左表** **join** **右表**

**左表**：在join关键字左边的表

**右表**：在join关键字右边的表

### 连接查询分类（join）

Sql将连接查询分成四类：内连接，外连接（不支持where连接；using连接，必须表有相同字段，结果相同字段去重），自然连接和交叉连接

#### 交叉连接

> 交叉连接：cross join，从一张表中循环取出每一条记录，每天记录都去另外一张表进行匹配。匹配一定保留（没有条件匹配），而连接本身字段就会增加，最终形成的结果叫笛迪卡尔积。
>

基本语法：左表 cross join 右表

**笛卡尔积没有意义，应尽量避免。**交叉连接存在的价值是保证连接结构的完整性。

#### 内连接

> 内连接（[inner]  join）:从左表中取出每一条记录，去右表中与所有的记录进行匹配，**匹配必须是某个条件在左表与右表中相同，**最终才会保留结果，否则不保留。
>

基本语法：左表 [inner]  join 右表 on 左表.字段=右表.字段

On表示连接条件，条件字段就是代表相同的业务含义

```sql
-- 内连接
select * from my_student as s inner join my_class as c on s.id = c.id;
```

![image-20200721164822257](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721164822257.png)

字段别名以及表别名的使用：**在查询数据的时候，不同表有同名字段，这个时候需要加上表名才能区分，而表名太长，通常使用别名。**

```sql
-- 内连接+别名
select s.*,c.name as c_name,c.room from
my_student as s inner join my_class as c
on s.id = c.id;
```

<img src="C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721164859240.png" alt="image-20200721164859240" style="zoom:80%;" />

内连接可以没有连接条件：**没有on之后的内容，这个时候系统会保留所有结果（笛卡尔积）**

内连接可以使用where代替on关键字**（where没有on效率高，on先过滤，而where是先形成笛卡尔积，再查询）**。On连接时使用的条件，where是过滤用的。

![image-20200721164927263](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721164927263.png)

#### 外连接

> 外连接：outer join，以某张表为主，取出其所有记录，然后每条与另外一张表进行连接。
>

- 左连接

```sql
select s.*,c.name as c_name,c.room from
my_student as s left join my_class as c  -- my_student为主表
on s.id = c.id;
```

![image-20200721165011885](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165011885.png)

- 右连接

```sql
select s.*,c.name as c_name,c.room from
my_student as s right join my_class as c -- my_class 为主表
on s.id = c.id;
```

![image-20200721165023013](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165023013.png)

虽然左连接和右连接有主表差异，但是显示的结果：左表的数据在左表，右表的数据在右边，左连接和右连接可以互换。

- 全外连接

左表和右表都不做限制，所有的记录都显示，两表不足的地方用null 填充。 全外连接不支持（+）这种写法。

两个表都允许有空值 

#### 自然连接（natural join）

> 自然连接，**就是自动匹配连接条件：系统以字段名字作为匹配条件（同名字段作为条件，多个同名字段都作为条件）。**
>

自然连接分为**自然内连接**和**自然外连接**。

- 自然内连接：natural join

  自然连接自动使用同名字段作为连接条件，连接之后会合并同名字段。

  ![image-20200721165055085](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165055085.png)

- 自然外连接：**左表** **natural left/right join** **右表**

- 
  其实内连接和外连接都可以模拟自然连接，使用同名字段，合并字段。

  左表 left/right/inner join 右表 using（字段名）; -- 使用同名字段作为连接条件，自动合并条件。

- 外连接模拟自然连接：using

  ```sql
  select * from my_student left join my_class using(id);
  ```

  ![image-20200721165205868](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165205868.png)

## 2.7 UNION

JOIN是字段连接，而UNION是数据连接

> 联合查询：将多次查询（多条select语句），在记录上进行拼接（字段不会增加）。UNION 操作符用于合并两个或多个 SELECT 语句的结果集。

请注意，UNION 内部的 SELECT 语句**必须拥有相同数量的列**。列也必须拥有相似的数据类型。同时，**每条SELECT语句中的列的顺序必须相同。**

### 2.7.1 基本语法

多条select语句构成，每一条select语句获取的字段数必须严格一致（但是字段类型无关）

```sql
Select 语句1
Union[union选项]
Select 语句2 .........
```

| Union选项 |                            |
| --------- | -------------------------- |
| all       | 保留所有                   |
| distinct  | 去除（整个重复），默认的。 |

联合查询只要求字段一样，跟数据类型无关。 

### 2.7.2 union和union all？

union在进行表求并集后去掉重复的元素，所以会对所产生的结果集进行排序运算，删除重复的记录再返回结果。

union all则只是简单地将两个结果集合并后就返回结果。

在执行查询操作时，union all要比union快得多。

### 2.7.3 与order by使用

在联合查询中：order by不能直接使用，需要对查询语句使用括号才行。

```sql
(select * from my_friend where sex = '男' order by age asc)
union
(select * from my_friend where sex = '女' order by age desc);
```

<img src="C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165233784.png" alt="image-20200721165233784" style="zoom:80%;" />

若要order by生效，必须搭配limit。Limit使用限定的最大数即可。

```sql
(select * from my_friend where sex = '男' order by age asc limit 9999999)
union
(select * from my_friend where sex = '女' order by age desc limit 9999999);
```

<img src="C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721165302458.png" alt="image-20200721165302458"  />

## 2.8 SELECT INTO 

SELECT INTO 语句从一个表中选取数据，然后把数据插入另一个表中，保存起来。

**SELECT INTO** **语句常用于创建表的备份复件或者用于对记录进行存档。**

下面的例子会创建一个名为 "Persons_Order_Backup" 的新表，其中包含了从 Persons 和 Orders 两个表中取得的信息：

```SQL
SELECT Persons.LastName,Orders.OrderNo
INTO Persons_Order_Backup
FROM Persons
INNER JOIN Orders
ON Persons.Id_P=Orders.Id_P
```

Select * into outfile ‘文件地址’ from xxxx

可以自动创建文件，不能重写已有文件。默认的，采用行区分记录。制表符区分字段。

**为了满足特殊的需求，可以采用不同的分割方式。支持，在导出数据，指定记录和字段的分割方式。**

```sql
Select * into outfile ‘c:/amp/one’
Fields terminated by ‘,’ enclosed by ‘x’//字段包裹符
Lines terminated by ‘/n’ starting by ‘start:’//记录开始的名字
From xxxx
```

**同时支持 into dumpfile，作用与outfile一致，不过是不做任何换行和转义处理。非常适合导出二进制数据。**



导入：从一个文本内容导入，我们刚刚导出的。

语法：

LOAD DATA INFILE '*file_name*.txt'  [REPLACE | IGNORE]  INTO TABLE *tbl_name*  

[FIELDS    [TERMINATED BY '*string*']    [[OPTIONALLY] ENCLOSED BY '*char*']    [ESCAPED BY '*char*' ]  ]  

[LINES    [STARTING BY '*string*']    [TERMINATED BY '*string*']  ]  

[IGNORE *number* LINES]

应该根据数据格式导入：

格式语法：

默认为：

字段：fields terminated by '\t' enclosed by '' escaped by '\\‘

记录：lines terminated by '\n' starting by ''

其他常用的是：字段使用逗号分割，而使用引号包裹

获取数据的字符集，受character_set_database配置的限制。注意，不受客户端的字符集的影响。

在导入数据时，如果出现主键冲突，可选的：忽略 或 替换。

Load data infile ‘file’ Ignore replace

可以选择在文本文件开始出，忽略若干行再进行导入。

Into table tbl_name ignore N lines;

## 2.9 NULL值 

**null判断不能使用 =要用 is ;**

如果表中的某个列是可选的，那么我们可以在不向该列添加值的情况下插入新记录或更新已有的记录。这意味着该字段将以 NULL 值保存。

NULL 值的处理方式与其他值不同。

NULL 用作未知的或不适用的值的占位符。

**注释：**无法比较 NULL 和 0；它们是不等价的。

 

**SQL IS NULL**

我们如何仅仅选取在 "Address" 列中带有 NULL 值的记录呢？

我们必须使用 IS NULL 操作符：

SELECT LastName,FirstName,Address FROM Persons

WHERE Address IS NULL

**SQL IS NOT NULL**

我们如何选取在 "Address" 列中不带有 NULL 值的记录呢？

我们必须使用 IS NOT NULL 操作符：

SELECT LastName,FirstName,Address FROM Persons

WHERE Address IS NOT NULL

## 2.10 NULL 函数

ISNULL()、NVL()、IFNULL() 和 COALESCE()函数

请看下面的 "Products" 表：

| **P_Id** | **ProductName** | **UnitPrice** | **UnitsInStock** | **UnitsOnOrder** |
| -------- | --------------- | ------------- | ---------------- | ---------------- |
| 1        | computer        | 699           | 25               | 15               |
| 2        | printer         | 365           | 36               |                  |
| 3        | telephone       | 280           | 159              | 57               |

假如 "UnitsOnOrder" 是可选的，而且可以包含 NULL 值。
我们使用如下 SELECT 语句：

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+UnitsOnOrder) FROM Products;
```

在上面的例子中，如果有 "UnitsOnOrder" 值是 NULL，那么结果是 NULL。

在这里，我们希望 NULL 值为 0。下面，如果 "UnitsOnOrder" 是 NULL，则不利于计算，因此如果值是 NULL 则 ISNULL() 返回 0。

**IFNULL() 函数**

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+IFNULL(UnitsOnOrder,0)) FROM Products;
```

**COALESCE() 函数**

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+COALESCE(UnitsOnOrder,0))FROM Products;
```

## 2.11 子查询

> 子查询：sub query，查询时在某个查询结果之上进行（一条select语句内包含另外一条select语句）。

group by …       ---不可以有子查询
order by …        ---不可以有子查询

### 子查询分类

- **按位置分类**：子查询（select语句）在外部查询（select语句）中出现的位置。

| From子查询   | 子查询跟在from之后      |
| ------------ | ----------------------- |
| Where子查询  | 子查询出现在where条件中 |
| Exists子查询 | 子查询出现在exists里面  |

- **按结果分类**：根据子查询得到的数据进行分类（理论上讲任何一个查询得到的结果都可以理解为二维表）。

| 标量子查询 | 子查询得到的结果是一行一列。（在where之后） |
| ---------- | ------------------------------------------- |
| 列子查询   | 子查询得到的结果是一列多行。（在where之后） |
| 行子查询   | 子查询得到的结果是一行多列。（在where之后） |
| 表子查询   | 子查询得到的结果是多行多列。（在from之后）  |

- **按照子查询返回的条目数分类**：单行子查询和多行子查询

  在**select中放子查询**时，要求只能是单行子查询。

  单行操作符对应单行子查询，多行操作符（in，any，all）对应多行子查询。

| IN   |                                                              |
| ---- | ------------------------------------------------------------ |
| ANY  | 小于某集合中的任意一个值，就是小于集合中的最大值。<br/>大于某集合中的任意一个值，就是大于最小值。 |
| ALL  | 小于某集合中的所有值，就是小于最小值。<br/>大于某集合中的所有值，就是大于最大值。 |

### 标量子查询

需求：知道班级名字为PHP0810后，获取该表所有学生。

**代码：**

```sql
Select * from my_student where c_id = (Select id from my_class where c_name = 'PHP0810')
```

### 列子查询

需求：查询所有在读班级的学生（班级表中存在的班级）

![image-20200721183541530](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200721183541530.png)

列子查询返回的结果比较：一列多行，需要使用in作为条件匹配。其中在mysql中还有几个类似的条件：all，some，any

- =any等价于in（其中一个满足即可）。
- Any与some是一样的。
- =all即为全部。 **!=all** 等同于**not in**

**陈述语句代码：**

```sql
Select * from my_studentwhere c_id=any(Select id from my_class);
Select * from my_studentwhere c_id=some(Select id from my_class);
Select * from my_studentwhere c_id=all(Select id from my_class);
```

**否定语句代码：**

```sql
Select * from my_studentwhere c_id !=any(Select id from my_class); --  所有结果（NULL除外）//不等于集合中的某一字段即可。
Select * from my_studentwhere c_id !=all(Select id from my_class); -- my_class表中不存在的id，包括null。
```

### 行子查询

行子查询：返回的结果是一行多列（一行多列）

需求:要求查询整个学生中，年龄最大且身高是最高的学生。

1. 确定数据源：

   Select * from my_student where age =? And heigh = ?;

   Select * from my_student where (age ,heigh) = ?;

2. 确定最大的年龄和最高的身高

   Select max(age) from my_student;

   Select max(height) from my_student;

3. 行子查询：需要构造行元素，行元素由多个字段构成。


### 表子查询

表子查询：子查询返回的结果是多行多列的二维表，子查询返回的结果是当做二维表来使用的。

需求：找出**每一个班**最高的一个学生。

```sql
Select * from (select * from my_student order by height desc) as student group by c_id;
-- form后面必须跟一个表，所以要取一个临时表
```

### Exists和in子查询

Exists：是否存在的意思，exists子查询就是用来判断某些条件是否满足**（跨表）**，exists是接在where之后，**exists返回的结果只有0和1**。 与双重循环相似，外查询每条记录，子查询里面的表要全搜索。 

## 2.12 视图（view）

> 视图是存储在数据库中的查询的SQL 语句。视图建立后，在**数据字典**中存放的是视图的定义。
>
> **定义能力强于表，因为可以在多张表上定义视图，操作能力弱于表，控制能力相当**

**视图是一种有结构（有行有列）但是没有结果（结构中不真实存放数据）的虚拟表**，虚拟表的结构来源不是自己定义，而是从对应的基表中产生（视图的数据来源）。

1. 对用户来说已经是过滤好的复合条件的结果集。
2. 安全，使用视图的用户只能访问他们被允许查询的结果集
3. 数据独立：一旦视图的结构确定了，可以屏蔽表结构变化对用户的影响，源表增加列对视图没有影响；

### 创建视图

**基本语法：**

```sql
CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
  VIEW view_name [(column_list)]
  AS select_statement
  [WITH [CASCADED | LOCAL] CHECK OPTION]
```

 

**利用with check option**约束限制，保证更新视图是在该视图的权限范围之内。

**OR REPLACE**：表示替换已有视图



**创建视图**

- 创建单表视图：基表只有一个

- 创建多表视图：基表有多个


```sql
--视图：单表
create view my_v1 as select * from my_student;
create view my_v2 as select * from my_class;
--视图：多表
create view my_v3 as select s.*,c.c_name,c.room from my_student as s left join my_class as c on s.c_id = c.id;
```

![image-20200722085238356](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200722085238356.png)

### 查看视图

- **视图是一张虚拟表**，表的所有查看方式都适用于视图：

  - show tables;

  - Desc 视图名;//表的结构

  - Show create table视图名;

视图比表还是有一个关键字的区别：view；查看视图的创建语句时可以使用Show create view视图名;

- 视图一旦创建：系统会在视图对应的数据库文件夹下创建一个对应的结构文件：**frm文件**。


### 使用视图

视图的执行其实本质就是执行封装的select语句。视图一旦创建完毕，就可以像一个普通表那样使用，**视图主要用来查询。**

select \* from view 视图名;

### 修改视图

视图本身不可修改，但是视图来源是可以修改的。

Alter view 视图名 as 新的select语句;

注意：修改视图是指修改数据库中已存在的表的定义，当基表的某些字段发生改变时，可以通过修改视图来保持视图和基本表之间一致

### 删除视图

Drop view [IF EXISTS] 视图名;

### 视图的意义

- 视图可以接受sql语句，将一条复制的查询语句是在视图进行保存，以后可以直接对视图进行操作。

- 数据安全：视图操作主要是针对查询的，如果对视图结构进行处理（删除），不会影响基表数据（相对安全）。

- 视图往往是在大项目中使用，而且是多系统使用。可以对外提供有用的数据，但是隐藏关键（或无用）的数据，保证数据安全。

- 视图可以对外提供友好型：不同的视图提供不同的数据，对外专门设计。

- 视图可以更好（容易）的进行权限控制。

**视图和基本表的区别**

   1、视图是已经编译好的sql语句。而表不是 

   2、视图没有实际的物理记录。而表有。

   3、表是内容，视图是窗口

   4、表只用物理空间而视图不占用物理空间，视图只是逻辑概念的存在，表可以及时对它进行修改，但视图只能有创建的语句来修改

   5、表是内模式，视图是外模式

   6、视图是查看数据表的一种方法，可以查询数据表中某些字段构成的数据，只是一些SQL语句的集合。从安全的角度说，视图可以不给用户接触数据表，从而不知道表结构。

   7、表属于全局模式中的表，是实表；视图属于局部模式的表，是虚表。 

   8、视图的建立和删除只影响视图本身，不影响对应的基本表。

### 视图数据操作

视图的确可以进行数据写操作但是有很多限制

**新增数据**

数据新增就是直接对视图进行数据新增。

- 多表视图不能新增数据。

- **可以向单表视图插入数据**：但是视图中的字段必须包含”基表中所有不能为空（或没有默认值）的字段”。

- 单表视图是可以向基表插入数据的。

  select * from my_v2;

  select * from my_class;

  insert into my_v2 values(6,'PHP8888','D306');

  ![image-20200722090800015](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200722090800015.png)

在基表中的数据改变，视图也是，因为它是结构，显示数据的。

**删除数据**

- 多表视图不能删除数据

- 单表视图可以删除


**更新数据**

理论上单表视图和多表视图都可更新数据。

更新限制：**with check option**

如果对视图进行新增的时候，限定了某个字段有限制。那么视图进行数据更新操作时，系统会进行验证：保证更新后，数据依然可以被实体查询出来，否则不让更新。

**视图算法**

> 视图算法：系统对视图以及外部查询视图的select语句的一种解析方式。
>

**视图算法分为三种：**

| Undefined（未定义）     | 这不是一种实际使用的算法，是一种推卸责任的算法，告诉系统，视图没有定义算法，系统自己看着办。 |
| ----------------------- | ------------------------------------------------------------ |
| Temptable（临时表算法） | 系统应该先执行视图的select语句，后执行外部查询语句           |
| Merge（合并算法）       | 系统应该先将视图对应的select语句与外部查询视图的select语句进行合并，然后执行（效率高） |

- 算法指定：在创建视图的时候


Create algorithm =指定算法 view 视图名字  as  select语句;

- 视图算法选择：

如果视图的select语句中包含一个查询子句（五子句），而且很可能顺序比外部的查询语句要靠后一定要使用算法temptable，其他情况可以不使用指定（默认）。



# SQL 函数

## 合计函数

内建 SQL 函数的语法是：

```sql
SELECT function(列) FROM 表;
```

**注释：**如果在 SELECT 语句的项目列表中的众多其它表达式中使用 SELECT 语句，则这个 SELECT 必须使用 GROUP BY 语句！

**在 SQL Server** **中的合计函数**

| **函数**                                                     | **描述**                                                 |
| ------------------------------------------------------------ | -------------------------------------------------------- |
| AVG(column)                                                  | 返回某列的平均值                                         |
| BINARY_CHECKSUM                                              |                                                          |
| CHECKSUM                                                     |                                                          |
| CHECKSUM_AGG                                                 |                                                          |
| [COUNT(column)](http://www.w3school.com.cn/sql/sql_func_count.asp) | 返回某列的行数（不包括NULL值）                           |
| COUNT(*)                                                     | 返回被选行数                                             |
| COUNT(DISTINCT column)                                       | 返回相异结果的数目                                       |
| FIRST(column)                                                | 返回在指定的域中第一个记录的值（SQLServer2000 不支持）   |
| [LAST(column)](http://www.w3school.com.cn/sql/sql_func_last.asp) | 返回在指定的域中最后一个记录的值（SQLServer2000 不支持） |
| [MAX(column)](http://www.w3school.com.cn/sql/sql_func_max.asp) | 返回某列的最高值                                         |
| MIN(column)                                                  | 返回某列的最低值                                         |
| STDEV(column)                                                |                                                          |
| STDEVP(column)                                               |                                                          |
| SUM(column)                                                  | 返回某列的总和                                           |
| VAR(column)                                                  |                                                          |
| VARP(column)                                                 |                                                          |

## decode、 sign

decode（sign(score-60),-1,'fail','pass') as mark 里面用到两个函数sign和decode
sign语法，两个数字进行比较
sign(数字1-数字2)
如果-1,说明数字2大，0,表示一样，1表示数字1大
decode语法相当于if then
decode(判断条件,条件1,结果1,条件2,结果2,默认结果)
**案例：**
decode(sex,0,'男',1,'女','未知')
表示判断条件是sex字段，如果是0,显示输出男，1显示输出女，不是这两个值以外的默认为未知

## AVG 

AVG 函数返回数值列的平均值。**NULL 值不包括在计算中。**

**语法**

```sql
SELECT AVG(column_name) FROM table_name;
```

**SQL AVG()实例**

我们拥有下面这个 "Orders" 表：

| O_Id | OrderDate  | OrderPrice | Customer |
| ---- | ---------- | ---------- | -------- |
| 1    | 2008/12/29 | 1000       | Bush     |
| 2    | 2008/11/23 | 1600       | Carter   |
| 3    | 2008/10/05 | 700        | Bush     |
| 4    | 2008/09/28 | 300        | Bush     |
| 5    | 2008/08/06 | 2000       | Adams    |
| 6    | 2008/07/21 | 100        | Carter   |

现在，我们希望计算 "OrderPrice" 字段的平均值。

```sql
SELECT AVG(OrderPrice) AS OrderAverage FROM Orders;
```

结果集类似这样：

| **OrderAverage** |
| ---------------- |
| 950              |

**例子 2**

现在，我们希望找到 OrderPrice 值高于 OrderPrice 平均值的客户。

我们使用如下 SQL 语句：

```sql
SELECT Customer FROM Orders WHERE OrderPrice>(SELECT AVG(OrderPrice) FROM Orders);
```

结果集类似这样：

| **Customer** |
| ------------ |
| Bush         |
| Carter       |
| Adams        |

## COUNT

count(0)=count(1)=count(\*)

count(指定的有效值)--执行计划都会转化为count(\*)

如果指定的是列名，**会判断是否有null**，null不计算，慢一点

**执行效果上：**  

count(*)包括了所有的列，相当于行数，在统计结果的时候，**不会忽略列值为NULL，没有值返回0；**

- count(1)包括了忽略所有列，用1代表代码行，在统计结果的时候，不会忽略列值为NULL。（如果你的数据表没有主键，那么count(1)比count(\*)快。）
- count(列名)只包括列名那一列，在统计结果的时候，会忽略列值为空（这里的空不是只空字符串或者0，而是表示null）的计数，即某个字段值为NULL时，不统计。 

- **count(*)** 返回表中所有存在行的总数包括null，然而count(1) 返回的是去除null以外的所有行的总数。有默认值的也会被记录。（如果表里面只有一个字段那么是count(*)最快。）



**COUNT(column_name) 语法**

COUNT(column_name) **函数返回指定列的值的数目（NULL 不计入）：**

SELECT COUNT(column_name) FROM table_name

希望计算客户 "Carter" 的订单数：

```sql
SELECT COUNT(Customer) AS CustomerNilsen FROM Orders WHERE Customer='Carter';
```

**COUNT(*) 语法**

COUNT(*) 函数返回表中的记录数。

## GROUP BY 

> GROUP BY 语句用于结合合计函数，**根据一个或多个列对结果集进行分组。**
>

我们拥有下面这个 "Orders" 表：

| **O_Id** | **OrderDate** | **OrderPrice** | **Customer** |
| -------- | ------------- | -------------- | ------------ |
| 1        | 2008/12/29    | 1000           | Bush         |
| 2        | 2008/11/23    | 1600           | Carter       |
| 3        | 2008/10/05    | 700            | Bush         |
| 4        | 2008/09/28    | 300            | Bush         |
| 5        | 2008/08/06    | 2000           | Adams        |
| 6        | 2008/07/21    | 100            | Carter       |

现在，我们希望查找每个客户的总金额（总订单）。

我们想要使用 GROUP BY 语句对客户进行组合。

我们使用下列 SQL 语句：

SELECT Customer,SUM(OrderPrice) FROM Orders

GROUP BY Customer

结果集类似这样：



| **Customer** | **SUM(OrderPrice)** |
| ------------ | ------------------- |
| Bush         | 2000                |
| Carter       | 1700                |
| Adams        | 2000                |

## HAVING 

在 SQL 中增加 HAVING 子句原因是，**WHERE** **关键字无法与合计函数一起使用。**

 

**SQL HAVING** **实例**

我们拥有下面这个 "Orders" 表：

| **O_Id** | **OrderDate** | **OrderPrice** | **Customer** |
| -------- | ------------- | -------------- | ------------ |
| 1        | 2008/12/29    | 1000           | Bush         |
| 2        | 2008/11/23    | 1600           | Carter       |
| 3        | 2008/10/05    | 700            | Bush         |
| 4        | 2008/09/28    | 300            | Bush         |
| 5        | 2008/08/06    | 2000           | Adams        |
| 6        | 2008/07/21    | 100            | Carter       |

- 现在，我们希望查找订单总金额少于 2000 的客户。

  **我们使用如下 SQL 语句：**

  ```sql
  SELECT Customer,SUM(OrderPrice) FROM Orders GROUP BY Customer HAVING SUM(OrderPrice)<2000;
  ```

  **结果集类似：**

| **Customer** | **SUM(OrderPrice)** |
| ------------ | ------------------- |
| Carter       | 1700                |

- 现在我们希望查找客户 "Bush" 或 "Adams" 拥有超过 1500 的订单总金额。


```sql
SELECT Customer,SUM(OrderPrice) FROM Orders WHERE Customer='Bush' OR Customer='Adams' GROUP BY Customer HAVING SUM(OrderPrice)>1500;
```

​	**结果集：**

| **Customer** | **SUM(OrderPrice)** |
| ------------ | ------------------- |
| Bush         | 2000                |
| Adams        | 2000                |

# 存储过程

## 存储过程

> 是在大型数据库系统中，一组为了**完成特定功能的SQL语句集**，存储在数据库中，经过第**一次编译**后再次调用不需要再次编译。
>
> 用户通过**指定存储过程的名字并给出参数**（如果该存储过程带有参数）来执行它。存储过程是数据库中的一个重要对象。
>

 

和事务的区别：事务中可以有存储过程，存储过程中也可以有事务

 

**其优势主要体现在：**

1. **存储过程只在创造时进行编译**，以后每次执行存储过程都不需再重新编译，预编译的。而一般SQL 语句每执行一次就编译一次所以使用存储过程可提高数据库执行速度。
2. 当对数据库进行复杂操作时(如对多个表进行Update,Insert,Query,Delete 时）可将此**复杂操作用存储过程封装起来与数据库提供的事务处理结合一起使用。**这些操作，如果用程序来完成，就变成了一条条的SQL 语句，可能要多次连接数据库。而换成存储，**只需要连接一次数据库就可以了**。
3. 存储过程可以重复使用，可减少数据库开发人员的工作量，随时对存储过程进行修改。
4. 安全性高。可设定只有某此用户才具有对指定存储过程的**使用权。**
5. 更强的适应性：由于存储过程对数据库的访问是通过存储过程来进行的，因此数据库开发人员可以在不改动存储过程接口的情况下对数据库进行任何改动，而这些改动不会对应用程序造成影响。
6. 分布式工作：应用程序和数据库的编码工作可以分别独立进行，而不会相互压制。一般来说，存储过程的编写比基本SQL语句复杂，编写存储过程需要更高的技能，更丰富的经验。

## MySQL存储过程的创建

CREATE PROCEDURE 过程名([[IN|OUT|INOUT] 参数名 数据类型[**,**[IN|OUT|INOUT] 参数名 数据类型…]]) [特性 ...] 过程体

```sql
DELIMITER //
  CREATE PROCEDURE myproc(OUT s int)
    BEGIN
    SELECT COUNT(*) INTO s FROM students;
    END
 // DELIMITER ;
```

**分隔符**

MySQL默认以";"为分隔符，如果没有**声明分割符**，则编译器会把存储过程当成SQL语句进行处理，因此编译过程会报错，所以要事先用**“DELIMITER //”**声明当前段分隔符让编译器把两个"//"之间的内容当做存储过程的代码，不会执行这些代码；“DELIMITER ;”的意为把分隔符还原。

**参数** 

MySQL存储过程的参数用在存储过程的定义，共有三种参数类型,IN,OUT,INOUT,形式如： 

CREATE PROCEDURE([[IN |OUT |INOUT ] 参数名 数据类形…]) 

IN 输入参数：表示该参数的值必须在调用存储过程时指定，在存储过程中修改该参数的值不能被返回，为默认值

OUT 输出参数：该值可在存储过程内部被改变，并可返回 

INOUT 输入输出参数：调用时指定，并且可被改变和返回

**变量**

I. 变量定义 

DECLARE variable_name[,variable_name…] datatype [DEFAULT value]; 

其中，datatype 为MySQL的数据类型，如int, float, date, varchar(length) 

例如：declare l_int int unsigned default 400000

Ⅱ. 变量赋值 

set 变量名 = 表达式值[, variable_name = expression…]

**在MySQL客户端使用用户变量：**

select *'Hello World'* into @x; select @x;

set @y = *'Goodbye Cruel World'*; select @y;

**在存储过程中使用用户变量：**

SET @greeting='Hello';

**注意：** 
 ①用户变量名一般以@开头 
 ②滥用用户变量会导致程序难以理解及管理

Ⅲ. 用户变量

**注释**

双横杆 – ：一般用户单行注释

c风格： 一般用于多行注释/* 内容 */

## MySQL存储过程的查询

```sql
call procedure();-- 无参

call procedure(@x,@y,);-- 有参数(此处x、y为输出参数，为输入参数)
-- 用完后，直接使用select @x,@y;来查询x、y的值。

select name from mysql.proc where db='数据库名';-- 获取数据库中所有存储过程的名称

select routine_name from information_schema.routines where routine_schema ='demo';-- 获取数据库中所有存储过程的名称

show PROCEDURE STATUS where db = 'demo';-- 查看数据库中所有存储过程的状态 

show create procedure demo.p1;-- 查看数据库中某一个存储过程的详细信息

DROP PROCEDURE 存储过程名 -- 删除
```

## 触发器

> 触发器：**触发器可以看成是一个特殊的存储过程，存储过程是要显示调用去完成，而触发器可以自动完成。**比如：当数据库中的表发生**增删改**操作时，对应的触发器就可以执行对应的PL/SQL语句块；

**作用：**维护表的完整性，记录表的修改来审计表的相关信息；触发器经常用于加强数据的完整性约束和业务规则等等。

```sql
CREATE TRIGGER trigger_name
ON { table|view }
[ WITH ENCRYPTION ]
{
}
```

有**INSTEAD-OF**和**AFTER**两种触发器。触发器是一种专用类型的存储过程，它被捆绑到**表格或者视图**上。

- **INSTEAD-OF**触发器是替代数据操控语言(DML)语句对表格执行语句的存储过程。例如，如果我有一个用于TableA的INSTEAD-OF-UPDATE触发器，同时对这个表格执行一个更新语句，那么INSTEAD-OF-UPDATE触发器里的代码会执行，而不是我执行的更新语句则不会执行操作。
- **AFTER触发器**要在DML语句在数据库里使用之后才执行。这些类型的触发器对于监视发生在数据库表格里的数据变化十分好用。

**触发器分为：**

- DML触发器：当数据库服务器中发生数据操作语言事件时执行的存储过程，分为：After触发器和instead of触发器
- DDL触发器：特殊的触发器，在响应数据定义语言（DDL）语句时触发，一般用于数据库中执行管理任务。DDL触发器是响应**create、after、或drop**开头的语句而激活。

触发器用处还是很多的，比如校内网、开心网、Facebook，你发一个日志，自动通知好友，其实就是在增加日志时做一个后触发，再向通知表中写入条目。因为触发器效率高。

# 高级题目

## sql语句实现行转列的3种方法 

![image-20200722093542340](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200722093542340.png)

这里我用了三种方法来实现行转列第一种：静态行转列

```sql
select UserName 姓名,
sum(case Subject when '语文' then Source else 0 end) 语文,
sum(case Subject when '数学' then Source else 0 end) 数学,
sum(case Subject when '英语' then Source else 0 end) 英语 
from TestTable 
group by UserName
```

**用povit行转列**

```sql
select * from 
(select UserName,Subject,Source from TestTable) 
pivot(sum(Source) for Subject in(语文,数学,英语)
) pvt
```

**用存储过程行转列**

```sql
alter proc pro_test
@userImages varchar(200),
@Subject varchar(20),
@Subject1 varchar(200),
@TableName varchar(50)
as
 declare @sql varchar(max)='select * from (select '+@userImages+' from'+@TableName+') tab
pivot
(sum('+@Subject+') for Subject('+@Subject1+')) pvt'
exec (@sql)
go
exec pro_test 'UserName,Subject,Source',
'TestTable',
'Subject',
'语文，数学，英语'
```

![image-20200722093611113](C:\Users\Administrator\Desktop\JAVA基础\Datebase\SQL\SQL.assets\image-20200722093611113.png)

- 查找最晚入职员工的所有信息

```sql
SELECT * FROM  employees WHERE hire_date=(SELECT MAX(hire_date) FROM employees);
```

- 查找入职员工时间排名倒数第三的员工所有信息

```sql
SELECT * FROM employees WHERE hire_date = (SELECT DISTINCT hire_date FROM employees ORDER BY hire_date DESC LIMIT 2,1//第二个开始，一个。012);
```

- UPDATE SALARIES SET sex = CASE sex WHEN 'm' THEN 'f' ELSE 'm' END

  UPDATE SALARIES SET sex = CHAR ( ASCII(sex) ^ ASCII( 'm' ) ^ ASCII( 'f' ) );

- update TBL set Nmbr = case when Nmbr =0 then Nmbr +2 else Nmbr + 3 end;

- SELECT testtable2.* , ISNULL(department,'黑人')

  isnull 标示department为空的时候，显示后面的值，也就是department为空的时候，显示黑人

- 编写一个sql ,查询出第10大的数据

  SELECT **DISTINCT** Salary FROM Employee ORDER BY Salary DESC LIMIT 9,1;

- 获取前一百奇数的用户(odd user_id)value

  SELECT TOP 100 user_id FROM dbo.users WHERE user_id % 2 = 1 ORDER BY user_id

- **查找有五名及以上 student** **的 class**

  SELECT class FROM courses GROUP BY class HAVING count( DISTINCT student ) >= 5;

- **查找薪资大于其经理薪资的员工信息**

  SELECT E1.NAME AS Employee FROM Employee E1 **INNER JOIN** Employee E2 **ON** E1.ManagerId = E2.Id **AND** E1.Salary > E2.Salary;

- **查找没有订单的顾客信息：**

  左外链接

  SELECT C.Name AS Customers FROM Customers C LEFT JOIN Orders O ON C.Id = O.CustomerId **WHERE** O.CustomerId IS NULL;

  子查询

  WHERE Id NOT IN ( SELECT CustomerId FROM Orders );

- **将得分排序，并统计排名：**

  使用联结 join，条件是左表的分数小于等于右表的分数时，对右表的分数进行计数（即计算有几个不重复的分数大于自己，计算结果就是rank），然后根据id分组后，再根据分数降序排列

  ```sql
  SELECT S1.score,COUNT( DISTINCT S2.score ) Rank FROM Scores S1 INNER JOIN Scores S2 ON S1.score <= S2.score GROUP BY S1.id, S1.score ORDER BY S1.score DESC;
  select Score, (select count(distinct Score) from Scores s2 where s2.Score >= s1.Score) Rank from Scores s1 order by Score DE;
  ```