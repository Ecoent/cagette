import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { CompanyCourse } from "./CompanyCourse";
import { Group } from "./Group";
import { User } from "./User";

@Index("Course_teacherId", ["teacherId"], {})
@Index("Course_groupId", ["groupId"], {})
@Entity("Course", { schema: "db" })
export class Course {
  @PrimaryGeneratedColumn({ type: "int", name: "id" })
  id: number;

  @Column("varchar", { name: "name", length: 128 })
  name: string;

  @Column("date", { name: "date" })
  date: string;

  @Column("int", { name: "teacherId" })
  teacherId: number;

  @Column("int", { name: "groupId", nullable: true })
  groupId: number | null;

  @Column("date", { name: "end" })
  end: string;

  @Column("varchar", { name: "ref", length: 64 })
  ref: string;

  @OneToMany(
    () => CompanyCourse,
    companyCourse => companyCourse.course
  )
  companyCourses: CompanyCourse[];

  @ManyToOne(
    () => Group,
    group => group.courses,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => User,
    user => user.courses,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "teacherId", referencedColumnName: "id" }])
  teacher: User;
}
