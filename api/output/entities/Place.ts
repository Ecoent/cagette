import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { Distribution } from "./Distribution";
import { DistributionCycle } from "./DistributionCycle";
import { Group } from "./Group";
import { MultiDistrib } from "./MultiDistrib";

@Index("Place_amapId", ["groupId"], {})
@Entity("Place", { schema: "db" })
export class Place {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 64 })
  name: string;

  @Column("varchar", { name: "address1", nullable: true, length: 64 })
  address1: string | null;

  @Column("varchar", { name: "address2", nullable: true, length: 64 })
  address2: string | null;

  @Column("varchar", { name: "city", length: 64 })
  city: string;

  @Column("varchar", { name: "zipCode", length: 32 })
  zipCode: string;

  @Column("int", { name: "groupId" })
  groupId: number;

  @Column("double", { name: "lat", nullable: true, precision: 22 })
  lat: number | null;

  @Column("double", { name: "lng", nullable: true, precision: 22 })
  lng: number | null;

  @Column("varchar", { name: "country", nullable: true, length: 64 })
  country: string | null;

  @OneToMany(
    () => Distribution,
    distribution => distribution.place
  )
  distributions: Distribution[];

  @OneToMany(
    () => DistributionCycle,
    distributionCycle => distributionCycle.place
  )
  distributionCycles: DistributionCycle[];

  @OneToMany(
    () => Group,
    group => group.place2
  )
  groups: Group[];

  @OneToMany(
    () => MultiDistrib,
    multiDistrib => multiDistrib.place
  )
  multiDistribs: MultiDistrib[];

  @ManyToOne(
    () => Group,
    group => group.places,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;
}
