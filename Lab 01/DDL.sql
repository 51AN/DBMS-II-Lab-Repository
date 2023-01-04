create table customer(
    c_id VARCHAR2(20),
    c_name VARCHAR2(100),

    CONSTRAINT PK_c_id PRIMARY KEY (c_id)

);

create table customer_franchise(
    c_id VARCHAR2(20),
    f_name VARCHAR2(50),

    CONSTRAINT fk_c_id_cf FOREIGN KEY f_name REFERENCES customer(c_id),
    CONSTRAINT fk_f_name_cf FOREIGN KEY f_name REFERENCES franchise(f_name)

)

create table franchise(
    f_name VARCHAR2(50),
    CONSTRAINT pk_f_name PRIMARY KEY (f_name)
);

create table branch(
    branch_id VARCHAR2(20),
    f_name VARCHAR2(50),

    CONSTRAINT pk_branch_id PRIMARY KEY (branch_id),
    CONSTRAINT fk_f_name FOREIGN KEY f_name REFERENCES franchise(f_name)
);


create table chef(
    chef_id VARCHAR2(20),
    branch_id VARCHAR2(20),
    cuisine_id varchar2(20),

    CONSTRAINT pk_chef_id PRIMARY KEY (chef_id),
    CONSTRAINT fk_branch_id FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    CONSTRAINT fk_cuisine_id FOREIGN KEY (cuisine_id) REFERENCES cuisine(cuisine_id)
);

CREATE OR REPLACE TYPE ingredients AS VARRAY (20) OF VARCHAR2 (20) ;

create table cuisine(
    cuisine_id VARCHAR2(20),
    menu_id VARCHAR2(20),
    recipe ingredients,
    price int,
    calorie_count varchar2(10),
    CONSTRAINT pk_cuisine_id PRIMARY KEY(cuisine_id),
    CONSTRAINT fk_menu_id_cuisine FOREIGN KEY(menu_id) REFERENCES menu(menu_id)
);


create table menu(
    menu_id VARCHAR2(20),
    menu_name varchar2(100),

    CONSTRAINT pk_menu_id PRIMARY KEY(menu_id),

);

create table franchise_menu(
    f_name VARCHAR2(50),
    menu_id VARCHAR2(20),

    CONSTRAINT fk_f_name_fm FOREIGN KEY f_name REFERENCES franchise(f_name),
    CONSTRAINT fk_menu_id_fm FOREIGN KEY f_name REFERENCES menu(menu_id)

);

CREATE SEQUENCE menu_number_seq
MINVALUE 1
MAXVALUE 5
START WITH 1
INCREMENT BY 1
CACHE 5;

CREATE OR REPLACE
TRIGGER MENU_NUMBER_INCREMENT
BEFORE INSERT ON special_menu
FOR EACH ROW
BEGIN
    :NEW.menu_number := menu_number_seq . NEXTVAL ;
END ;
/

create table special_menu(
    chef_id VARCHAR2(20),
    menu_id VARCHAR2(20),
    menu_number int not null,

    CONSTRAINT fk_chef_id_owner FOREIGN KEY(chef_id) REFERENCES chef(chef_id),
    CONSTRAINT fk_menu_id_owner FOREIGN KEY menu_id REFERENCES menu(menu_id),
    check (menu_number <= 5)

)

create table prefered_cuisine(
    c_id VARCHAR2(20),
    cuisine_id VARCHAR2(20),

    CONSTRAINT fk_c_id_prefer FOREIGN KEY(c_id) REFERENCES customer(c_id),
    CONSTRAINT fk_cuisine_id_prefer FOREIGN KEY(cuisine_id) REFERENCES cuisine(cuisine_id)
);

create table rating(
    c_id VARCHAR2(20),
    f_name VARCHAR2(50),
    menu_id VARCHAR2(20),
    cuisine_id VARCHAR2(20),
    rating int,

    CONSTRAINT fk_c_id_rating FOREIGN KEY(c_id) REFERENCES customer(c_id),
    CONSTRAINT fk_cuisine_id_rating FOREIGN KEY(cuisine_id) REFERENCES cuisine(cuisine_id),
    CONSTRAINT fk_f_name_rating FOREIGN KEY f_name REFERENCES franchise(f_name),
    CONSTRAINT fk_menu_id_rating FOREIGN KEY f_name REFERENCES menu(menu_id)
);

create table order(
    order_id VARCHAR2(20),
    c_id VARCHAR2(20),
    cuisine_id VARCHAR2(20),
    f_name VARCHAR2(50),


    CONSTRAINT pk_order_id PRIMARY KEY (order_id),
    CONSTRAINT fk_c_id_order FOREIGN KEY(c_id) REFERENCES customer(c_id),
    CONSTRAINT fk_cuisine_id_order FOREIGN KEY(cuisine_id) REFERENCES cuisine(cuisine_id),
    CONSTRAINT fk_f_name_order FOREIGN KEY f_name REFERENCES franchise(f_name)
)