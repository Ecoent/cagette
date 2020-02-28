import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Basket } from "./Basket";
import { Distribution } from "./Distribution";
import { MangopayGroupPayOut } from "./MangopayGroupPayOut";
import { DistributionCycle } from "./DistributionCycle";
import { Group } from "./Group";
import { Place } from "./Place";
import { TmpBasket } from "./TmpBasket";
import { Volunteer } from "./Volunteer";

@Index("MultiDistrib_groupId", ["groupId"], {})
@Index("MultiDistrib_placeId", ["placeId"], {})
@Index("MultiDistrib_distributionCycleId", ["distributionCycleId"], {})
@Entity("MultiDistrib", { schema: "db" })
export class MultiDistrib {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("datetime", { name: "distribStartDate" })
  distribStartDate: Date;

  @Column("datetime", { name: "distribEndDate" })
  distribEndDate: Date;

  @Column("datetime", { name: "orderStartDate", nullable: true })
  orderStartDate: Date | null;

  @Column("datetime", { name: "orderEndDate", nullable: true })
  orderEndDate: Date | null;

  @Column("mediumtext", { name: "volunteerRolesIds", nullable: true })
  volunteerRolesIds: string | null;

  @Column("int", { name: "groupId" })
  groupId: number;

  @Column("int", { name: "placeId" })
  placeId: number;

  @Column("int", { name: "distributionCycleId", nullable: true })
  distributionCycleId: number | null;

  @Column("double", { name: "counterBeforeDistrib", precision: 22 })
  counterBeforeDistrib: number;

  @Column("tinyint", { name: "validated", nullable: true, width: 1 })
  validated: boolean | null;

  @OneToMany(
    () => Basket,
    basket => basket.multiDistrib
  )
  baskets: Basket[];

  @OneToMany(
    () => Distribution,
    distribution => distribution.multiDistrib
  )
  distributions: Distribution[];

  @OneToMany(
    () => MangopayGroupPayOut,
    mangopayGroupPayOut => mangopayGroupPayOut.multiDistrib
  )
  mangopayGroupPayOuts: MangopayGroupPayOut[];

  @ManyToOne(
    () => DistributionCycle,
    distributionCycle => distributionCycle.multiDistribs,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "distributionCycleId", referencedColumnName: "id" }])
  distributionCycle: DistributionCycle;

  @ManyToOne(
    () => Group,
    group => group.multiDistribs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => Place,
    place => place.multiDistribs,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "placeId", referencedColumnName: "id" }])
  place: Place;

  @OneToMany(
    () => TmpBasket,
    tmpBasket => tmpBasket.multiDistrib
  )
  tmpBaskets: TmpBasket[];

  @OneToMany(
    () => Volunteer,
    volunteer => volunteer.multiDistrib
  )
  volunteers: Volunteer[];
}
