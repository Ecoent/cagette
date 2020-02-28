import {
  Column,
  Entity,
  Index,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { Basket } from "./Basket";
import { Catalog } from "./Catalog";
import { CompanyCourse } from "./CompanyCourse";
import { Course } from "./Course";
import { Error } from "./Error";
import { Group } from "./Group";
import { MangopayLegalUser } from "./MangopayLegalUser";
import { MangopayUser } from "./MangopayUser";
import { Membership } from "./Membership";
import { Message } from "./Message";
import { Operation } from "./Operation";
import { PMessage } from "./PMessage";
import { PNotif } from "./PNotif";
import { PUserCompany } from "./PUserCompany";
import { Session } from "./Session";
import { Subscription } from "./Subscription";
import { TmpBasket } from "./TmpBasket";
import { UserGroup } from "./UserGroup";
import { UserOrder } from "./UserOrder";
import { Vendor } from "./Vendor";
import { Volunteer } from "./Volunteer";
import { WaitingList } from "./WaitingList";

@Index("User_email", ["email"], { unique: true })
@Entity("User", { schema: "db" })
export class User {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "lang", length: 2 })
  lang: string;

  @Column("tinytext", { name: "pass" })
  pass: string;

  @Column("int", { name: "rights" })
  rights: number;

  @Column("varchar", { name: "firstName", length: 32 })
  firstName: string;

  @Column("varchar", { name: "lastName", length: 32 })
  lastName: string;

  @Column("varchar", { name: "email", unique: true, length: 64 })
  email: string;

  @Column("varchar", { name: "phone", nullable: true, length: 19 })
  phone: string | null;

  @Column("varchar", { name: "firstName2", nullable: true, length: 32 })
  firstName2: string | null;

  @Column("varchar", { name: "lastName2", nullable: true, length: 32 })
  lastName2: string | null;

  @Column("varchar", { name: "email2", nullable: true, length: 64 })
  email2: string | null;

  @Column("varchar", { name: "phone2", nullable: true, length: 19 })
  phone2: string | null;

  @Column("varchar", { name: "address1", nullable: true, length: 64 })
  address1: string | null;

  @Column("varchar", { name: "address2", nullable: true, length: 64 })
  address2: string | null;

  @Column("varchar", { name: "zipCode", nullable: true, length: 32 })
  zipCode: string | null;

  @Column("varchar", { name: "city", nullable: true, length: 25 })
  city: string | null;

  @Column("datetime", { name: "ldate", nullable: true })
  ldate: Date | null;

  @Column("date", { name: "cdate" })
  cdate: string;

  @Column("int", { name: "flags" })
  flags: number;

  @Column("mediumblob", { name: "tutoState", nullable: true })
  tutoState: Buffer | null;

  @Column("varchar", { name: "apiKey", nullable: true, length: 128 })
  apiKey: string | null;

  @Column("varchar", { name: "nationality", nullable: true, length: 2 })
  nationality: string | null;

  @Column("tinyint", { name: "tos", width: 1 })
  tos: boolean;

  @Column("varchar", { name: "countryOfResidence", nullable: true, length: 2 })
  countryOfResidence: string | null;

  @Column("date", { name: "birthDate", nullable: true })
  birthDate: string | null;

  @OneToMany(
    () => Basket,
    basket => basket.user
  )
  baskets: Basket[];

  @OneToMany(
    () => Catalog,
    catalog => catalog.user
  )
  catalogs: Catalog[];

  @OneToMany(
    () => CompanyCourse,
    companyCourse => companyCourse.user
  )
  companyCourses: CompanyCourse[];

  @OneToMany(
    () => Course,
    course => course.teacher
  )
  courses: Course[];

  @OneToMany(
    () => Error,
    error => error.u
  )
  errors: Error[];

  @OneToMany(
    () => Group,
    group => group.user
  )
  groups: Group[];

  @OneToMany(
    () => Group,
    group => group.legalRepr
  )
  groups2: Group[];

  @OneToMany(
    () => MangopayLegalUser,
    mangopayLegalUser => mangopayLegalUser.legalRepr
  )
  mangopayLegalUsers: MangopayLegalUser[];

  @OneToOne(
    () => MangopayUser,
    mangopayUser => mangopayUser.user
  )
  mangopayUser: MangopayUser;

  @OneToMany(
    () => Membership,
    membership => membership.user
  )
  memberships: Membership[];

  @OneToMany(
    () => Message,
    message => message.sender
  )
  messages: Message[];

  @OneToMany(
    () => Operation,
    operation => operation.user
  )
  operations: Operation[];

  @OneToMany(
    () => PMessage,
    pMessage => pMessage.sender
  )
  pMessages: PMessage[];

  @OneToMany(
    () => PNotif,
    pNotif => pNotif.user
  )
  pNotifs: PNotif[];

  @OneToMany(
    () => PUserCompany,
    pUserCompany => pUserCompany.user
  )
  pUserCompanies: PUserCompany[];

  @OneToMany(
    () => Session,
    session => session.u
  )
  sessions: Session[];

  @OneToMany(
    () => Subscription,
    subscription => subscription.user
  )
  subscriptions: Subscription[];

  @OneToMany(
    () => TmpBasket,
    tmpBasket => tmpBasket.user
  )
  tmpBaskets: TmpBasket[];

  @OneToMany(
    () => UserGroup,
    userGroup => userGroup.user
  )
  userGroups: UserGroup[];

  @OneToMany(
    () => UserOrder,
    userOrder => userOrder.user
  )
  userOrders: UserOrder[];

  @OneToMany(
    () => UserOrder,
    userOrder => userOrder.userId3
  )
  userOrders2: UserOrder[];

  @OneToMany(
    () => Vendor,
    vendor => vendor.user
  )
  vendors: Vendor[];

  @OneToMany(
    () => Volunteer,
    volunteer => volunteer.user
  )
  volunteers: Volunteer[];

  @OneToMany(
    () => WaitingList,
    waitingList => waitingList.user
  )
  waitingLists: WaitingList[];
}
