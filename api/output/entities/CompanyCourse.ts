import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { CagettePro } from "./CagettePro";
import { Course } from "./Course";
import { User } from "./User";

@Index("CompanyCourse_courseId", ["courseId"], {})
@Index("CompanyCourse_userId", ["userId"], {})
@Entity("CompanyCourse", { schema: "db" })
export class CompanyCourse {
  @Column("int", { primary: true, name: "companyId" })
  companyId: number;

  @Column("int", { primary: true, name: "courseId" })
  courseId: number;

  @Column("int", { name: "userId", nullable: true })
  userId: number | null;

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.companyCourses,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => Course,
    course => course.companyCourses,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "courseId", referencedColumnName: "id" }])
  course: Course;

  @ManyToOne(
    () => User,
    user => user.companyCourses,
    { onDelete: "SET NULL", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
