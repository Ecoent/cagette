import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Catalog } from "./Catalog";
import { CategoryGroup } from "./CategoryGroup";
import { Course } from "./Course";
import { DistributionCycle } from "./DistributionCycle";
import { User } from "./User";
import { File } from "./File";
import { Place } from "./Place";
import { LemonWayConfig } from "./LemonWayConfig";
import { MangopayLegalUserGroup } from "./MangopayLegalUserGroup";
import { Membership } from "./Membership";
import { Message } from "./Message";
import { MultiDistrib } from "./MultiDistrib";
import { Operation } from "./Operation";
import { PNotif } from "./PNotif";
import { UserGroup } from "./UserGroup";
import { VolunteerRole } from "./VolunteerRole";
import { WaitingList } from "./WaitingList";

@Index("Amap_userId", ["userId"], {})
@Index("Amap_imageId", ["imageId"], {})
@Index("Amap_placeId", ["placeId"], {})
@Index("Amap_legalReprId", ["legalReprId"], {})
@Entity("Group", { schema: "db" })
export class Group {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 64 })
  name: string;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @Column("mediumtext", { name: "txtDistrib", nullable: true })
  txtDistrib: string | null;

  @Column("mediumtext", { name: "txtIntro", nullable: true })
  txtIntro: string | null;

  @Column("int", { name: "flags" })
  flags: number;

  @Column("date", { name: "membershipRenewalDate", nullable: true })
  membershipRenewalDate: string | null;

  @Column("tinyint", { name: "membershipPrice", nullable: true })
  membershipPrice: number | null;

  @Column("mediumtext", { name: "txtHome", nullable: true })
  txtHome: string | null;

  @Column("mediumblob", { name: "vatRates" })
  vatRates: Buffer;

  @Column("int", { name: "imageId", nullable: true })
  imageId: number | null;

  @Column("datetime", { name: "cdate" })
  cdate: Date;

  @Column("int", { name: "placeId", nullable: true })
  placeId: number | null;

  @Column("tinyint", { name: "regOption", unsigned: true })
  regOption: number;

  @Column("varchar", { name: "currencyCode", length: 3 })
  currencyCode: string;

  @Column("varchar", { name: "currency", length: 12 })
  currency: string;

  @Column("varchar", { name: "extUrl", nullable: true, length: 64 })
  extUrl: string | null;

  @Column("varchar", { name: "IBAN", nullable: true, length: 40 })
  iban: string | null;

  @Column("mediumblob", { name: "allowedPaymentsType", nullable: true })
  allowedPaymentsType: Buffer | null;

  @Column("varchar", { name: "checkOrder", nullable: true, length: 64 })
  checkOrder: string | null;

  @Column("tinyint", { name: "groupType", nullable: true, unsigned: true })
  groupType: number | null;

  @Column("tinyint", {
    name: "allowMoneyPotWithNegativeBalance",
    nullable: true,
    width: 1
  })
  allowMoneyPotWithNegativeBalance: boolean | null;

  @Column("int", { name: "legalReprId", nullable: true })
  legalReprId: number | null;

  @Column("tinyint", { name: "volunteersMailDaysBeforeDutyPeriod" })
  volunteersMailDaysBeforeDutyPeriod: number;

  @Column("int", { name: "daysBeforeDutyPeriodsOpen" })
  daysBeforeDutyPeriodsOpen: number;

  @Column("mediumtext", { name: "volunteersMailContent" })
  volunteersMailContent: string;

  @Column("tinyint", { name: "vacantVolunteerRolesMailDaysBeforeDutyPeriod" })
  vacantVolunteerRolesMailDaysBeforeDutyPeriod: number;

  @Column("mediumtext", { name: "alertMailContent" })
  alertMailContent: string;

  @Column("int", { name: "betaFlags" })
  betaFlags: number;

  @OneToMany(
    () => Catalog,
    catalog => catalog.group
  )
  catalogs: Catalog[];

  @OneToMany(
    () => CategoryGroup,
    categoryGroup => categoryGroup.amap
  )
  categoryGroups: CategoryGroup[];

  @OneToMany(
    () => Course,
    course => course.group
  )
  courses: Course[];

  @OneToMany(
    () => DistributionCycle,
    distributionCycle => distributionCycle.group
  )
  distributionCycles: DistributionCycle[];

  @ManyToOne(
    () => User,
    user => user.groups,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @ManyToOne(
    () => File,
    file => file.groups,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "imageId", referencedColumnName: "id" }])
  image: File;

  @ManyToOne(
    () => User,
    user => user.groups2,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "legalReprId", referencedColumnName: "id" }])
  legalRepr: User;

  @ManyToOne(
    () => Place,
    place => place.groups,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "placeId", referencedColumnName: "id" }])
  place2: Place;

  @OneToMany(
    () => LemonWayConfig,
    lemonWayConfig => lemonWayConfig.group
  )
  lemonWayConfigs: LemonWayConfig[];

  @OneToMany(
    () => MangopayLegalUserGroup,
    mangopayLegalUserGroup => mangopayLegalUserGroup.group
  )
  mangopayLegalUserGroups: MangopayLegalUserGroup[];

  @OneToMany(
    () => Membership,
    membership => membership.amap
  )
  memberships: Membership[];

  @OneToMany(
    () => Message,
    message => message.amap
  )
  messages: Message[];

  @OneToMany(
    () => MultiDistrib,
    multiDistrib => multiDistrib.group
  )
  multiDistribs: MultiDistrib[];

  @OneToMany(
    () => Operation,
    operation => operation.group
  )
  operations: Operation[];

  @OneToMany(
    () => PNotif,
    pNotif => pNotif.group
  )
  pNotifs: PNotif[];

  @OneToMany(
    () => Place,
    place => place.group
  )
  places: Place[];

  @OneToMany(
    () => UserGroup,
    userGroup => userGroup.group
  )
  userGroups: UserGroup[];

  @OneToMany(
    () => VolunteerRole,
    volunteerRole => volunteerRole.group
  )
  volunteerRoles: VolunteerRole[];

  @OneToMany(
    () => WaitingList,
    waitingList => waitingList.amap
  )
  waitingLists: WaitingList[];
}
