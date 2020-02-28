import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { User } from "./User";
import { Group } from "./Group";
import { Vendor } from "./Vendor";
import { Distribution } from "./Distribution";
import { Product } from "./Product";
import { Subscription } from "./Subscription";
import { VolunteerRole } from "./VolunteerRole";
import { WConfig } from "./WConfig";

@Index("Contract_vendorId", ["vendorId"], {})
@Index("Contract_userId", ["userId"], {})
@Index("Contract_amapId", ["groupId"], {})
@Entity("Catalog", { schema: "db" })
export class Catalog {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 64 })
  name: string;

  @Column("date", { name: "startDate" })
  startDate: string;

  @Column("date", { name: "endDate" })
  endDate: string;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @Column("int", { name: "vendorId" })
  vendorId: number;

  @Column("int", { name: "groupId" })
  groupId: number;

  @Column("tinyint", { name: "distributorNum" })
  distributorNum: number;

  @Column("int", { name: "flags" })
  flags: number;

  @Column("varchar", { name: "percentageName", nullable: true, length: 64 })
  percentageName: string | null;

  @Column("double", { name: "percentageValue", nullable: true, precision: 22 })
  percentageValue: number | null;

  @Column("int", { name: "type" })
  type: number;

  @Column("mediumtext", { name: "description", nullable: true })
  description: string | null;

  @ManyToOne(
    () => User,
    user => user.catalogs,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @ManyToOne(
    () => Group,
    group => group.catalogs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => Vendor,
    vendor => vendor.catalogs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "vendorId", referencedColumnName: "id" }])
  vendor: Vendor;

  @OneToMany(
    () => Distribution,
    distribution => distribution.catalog
  )
  distributions: Distribution[];

  @OneToMany(
    () => Product,
    product => product.catalog
  )
  products: Product[];

  @OneToMany(
    () => Subscription,
    subscription => subscription.catalog
  )
  subscriptions: Subscription[];

  @OneToMany(
    () => VolunteerRole,
    volunteerRole => volunteerRole.catalog
  )
  volunteerRoles: VolunteerRole[];

  @OneToMany(
    () => WConfig,
    wConfig => wConfig.contract
  )
  wConfigs: WConfig[];
}
