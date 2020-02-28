import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Volunteer } from "./Volunteer";
import { Catalog } from "./Catalog";
import { Group } from "./Group";

@Index("VolunteerRole_groupId", ["groupId"], {})
@Index("VolunteerRole_contractId", ["catalogId"], {})
@Entity("VolunteerRole", { schema: "db" })
export class VolunteerRole {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 64 })
  name: string;

  @Column("int", { name: "groupId" })
  groupId: number;

  @Column("int", { name: "catalogId", nullable: true })
  catalogId: number | null;

  @OneToMany(
    () => Volunteer,
    volunteer => volunteer.volunteerRole
  )
  volunteers: Volunteer[];

  @ManyToOne(
    () => Catalog,
    catalog => catalog.volunteerRoles,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "catalogId", referencedColumnName: "id" }])
  catalog: Catalog;

  @ManyToOne(
    () => Group,
    group => group.volunteerRoles,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;
}
