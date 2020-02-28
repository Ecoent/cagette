import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Group } from "./Group";
import { Place } from "./Place";
import { MultiDistrib } from "./MultiDistrib";

@Index("DistributionCycle_placeId", ["placeId"], {})
@Index("DistributionCycle_groupId", ["groupId"], {})
@Entity("DistributionCycle", { schema: "db" })
export class DistributionCycle {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("tinyint", { name: "cycleType", unsigned: true })
  cycleType: number;

  @Column("date", { name: "startDate" })
  startDate: string;

  @Column("date", { name: "endDate" })
  endDate: string;

  @Column("datetime", { name: "startHour" })
  startHour: Date;

  @Column("datetime", { name: "endHour" })
  endHour: Date;

  @Column("int", { name: "groupId" })
  groupId: number;

  @Column("int", { name: "placeId" })
  placeId: number;

  @Column("tinyint", { name: "daysBeforeOrderStart", nullable: true })
  daysBeforeOrderStart: number | null;

  @Column("tinyint", { name: "daysBeforeOrderEnd", nullable: true })
  daysBeforeOrderEnd: number | null;

  @Column("date", { name: "closingHour", nullable: true })
  closingHour: string | null;

  @Column("date", { name: "openingHour", nullable: true })
  openingHour: string | null;

  @ManyToOne(
    () => Group,
    group => group.distributionCycles,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => Place,
    place => place.distributionCycles,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "placeId", referencedColumnName: "id" }])
  place: Place;

  @OneToMany(
    () => MultiDistrib,
    multiDistrib => multiDistrib.distributionCycle
  )
  multiDistribs: MultiDistrib[];
}
