
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00028117          	auipc	sp,0x28
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	2a8000ef          	jal	ra,802002b0 <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00001097          	auipc	ra,0x1
    80200018:	800080e7          	jalr	-2048(ra) # 80200814 <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <finished>:

// Count finished programs. If all apps exited, shutdown.
int finished()
{
	static int fin = 0;
	if (++fin >= app_num)
    80200030:	0006a717          	auipc	a4,0x6a
    80200034:	35070713          	addi	a4,a4,848 # 8026a380 <fin.0>
    80200038:	431c                	lw	a5,0(a4)
    8020003a:	2785                	addiw	a5,a5,1
    8020003c:	0007869b          	sext.w	a3,a5
    80200040:	c31c                	sw	a5,0(a4)
    80200042:	0006a797          	auipc	a5,0x6a
    80200046:	34e7b783          	ld	a5,846(a5) # 8026a390 <app_num>
    8020004a:	00f6f463          	bgeu	a3,a5,80200052 <finished+0x22>
		panic("all apps over");
	return 0;
}
    8020004e:	4501                	li	a0,0
    80200050:	8082                	ret
{
    80200052:	1141                	addi	sp,sp,-16
    80200054:	e406                	sd	ra,8(sp)
    80200056:	e022                	sd	s0,0(sp)
    80200058:	0800                	addi	s0,sp,16
		panic("all apps over");
    8020005a:	00000097          	auipc	ra,0x0
    8020005e:	518080e7          	jalr	1304(ra) # 80200572 <threadid>
    80200062:	86aa                	mv	a3,a0
    80200064:	47b9                	li	a5,14
    80200066:	00002717          	auipc	a4,0x2
    8020006a:	f9a70713          	addi	a4,a4,-102 # 80202000 <e_text>
    8020006e:	00002617          	auipc	a2,0x2
    80200072:	fa260613          	addi	a2,a2,-94 # 80202010 <e_text+0x10>
    80200076:	45fd                	li	a1,31
    80200078:	00002517          	auipc	a0,0x2
    8020007c:	fa050513          	addi	a0,a0,-96 # 80202018 <e_text+0x18>
    80200080:	00000097          	auipc	ra,0x0
    80200084:	31c080e7          	jalr	796(ra) # 8020039c <printf>
    80200088:	00000097          	auipc	ra,0x0
    8020008c:	7bc080e7          	jalr	1980(ra) # 80200844 <shutdown>
}
    80200090:	4501                	li	a0,0
    80200092:	60a2                	ld	ra,8(sp)
    80200094:	6402                	ld	s0,0(sp)
    80200096:	0141                	addi	sp,sp,16
    80200098:	8082                	ret

000000008020009a <loader_init>:

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void loader_init()
{
    8020009a:	1141                	addi	sp,sp,-16
    8020009c:	e406                	sd	ra,8(sp)
    8020009e:	e022                	sd	s0,0(sp)
    802000a0:	0800                	addi	s0,sp,16
	if ((uint64)ekernel >= BASE_ADDRESS) {
    802000a2:	0006b717          	auipc	a4,0x6b
    802000a6:	f5e70713          	addi	a4,a4,-162 # 8026b000 <e_bss>
    802000aa:	20100793          	li	a5,513
    802000ae:	07da                	slli	a5,a5,0x16
    802000b0:	06f77463          	bgeu	a4,a5,80200118 <loader_init+0x7e>
		panic("kernel too large...\n");
	}
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    802000b4:	00003797          	auipc	a5,0x3
    802000b8:	f4c78793          	addi	a5,a5,-180 # 80203000 <_app_num>
    802000bc:	0007c683          	lbu	a3,0(a5)
    802000c0:	0017c703          	lbu	a4,1(a5)
    802000c4:	0722                	slli	a4,a4,0x8
    802000c6:	8ed9                	or	a3,a3,a4
    802000c8:	0027c703          	lbu	a4,2(a5)
    802000cc:	0742                	slli	a4,a4,0x10
    802000ce:	8f55                	or	a4,a4,a3
    802000d0:	0037c683          	lbu	a3,3(a5)
    802000d4:	06e2                	slli	a3,a3,0x18
    802000d6:	8f55                	or	a4,a4,a3
    802000d8:	0047c683          	lbu	a3,4(a5)
    802000dc:	1682                	slli	a3,a3,0x20
    802000de:	8ed9                	or	a3,a3,a4
    802000e0:	0057c703          	lbu	a4,5(a5)
    802000e4:	1722                	slli	a4,a4,0x28
    802000e6:	8ed9                	or	a3,a3,a4
    802000e8:	0067c703          	lbu	a4,6(a5)
    802000ec:	1742                	slli	a4,a4,0x30
    802000ee:	8f55                	or	a4,a4,a3
    802000f0:	0077c783          	lbu	a5,7(a5)
    802000f4:	17e2                	slli	a5,a5,0x38
    802000f6:	8fd9                	or	a5,a5,a4
    802000f8:	0006a717          	auipc	a4,0x6a
    802000fc:	28f73c23          	sd	a5,664(a4) # 8026a390 <app_num>
	app_info_ptr++;
    80200100:	00003797          	auipc	a5,0x3
    80200104:	f0878793          	addi	a5,a5,-248 # 80203008 <_app_num+0x8>
    80200108:	0006a717          	auipc	a4,0x6a
    8020010c:	28f73023          	sd	a5,640(a4) # 8026a388 <app_info_ptr>
}
    80200110:	60a2                	ld	ra,8(sp)
    80200112:	6402                	ld	s0,0(sp)
    80200114:	0141                	addi	sp,sp,16
    80200116:	8082                	ret
		panic("kernel too large...\n");
    80200118:	00000097          	auipc	ra,0x0
    8020011c:	45a080e7          	jalr	1114(ra) # 80200572 <threadid>
    80200120:	86aa                	mv	a3,a0
    80200122:	47d9                	li	a5,22
    80200124:	00002717          	auipc	a4,0x2
    80200128:	edc70713          	addi	a4,a4,-292 # 80202000 <e_text>
    8020012c:	00002617          	auipc	a2,0x2
    80200130:	ee460613          	addi	a2,a2,-284 # 80202010 <e_text+0x10>
    80200134:	45fd                	li	a1,31
    80200136:	00002517          	auipc	a0,0x2
    8020013a:	f0a50513          	addi	a0,a0,-246 # 80202040 <e_text+0x40>
    8020013e:	00000097          	auipc	ra,0x0
    80200142:	25e080e7          	jalr	606(ra) # 8020039c <printf>
    80200146:	00000097          	auipc	ra,0x0
    8020014a:	6fe080e7          	jalr	1790(ra) # 80200844 <shutdown>
    8020014e:	b79d                	j	802000b4 <loader_init+0x1a>

0000000080200150 <load_app>:

// Load nth user app at
// [BASE_ADDRESS + n * MAX_APP_SIZE, BASE_ADDRESS + (n+1) * MAX_APP_SIZE)
int load_app(int n, uint64 *info)
{
    80200150:	7179                	addi	sp,sp,-48
    80200152:	f406                	sd	ra,40(sp)
    80200154:	f022                	sd	s0,32(sp)
    80200156:	ec26                	sd	s1,24(sp)
    80200158:	e84a                	sd	s2,16(sp)
    8020015a:	e44e                	sd	s3,8(sp)
    8020015c:	1800                	addi	s0,sp,48
	uint64 start = info[n], end = info[n + 1], length = end - start;
    8020015e:	00351793          	slli	a5,a0,0x3
    80200162:	95be                	add	a1,a1,a5
    80200164:	0005b983          	ld	s3,0(a1)
    80200168:	0085b903          	ld	s2,8(a1)
    8020016c:	41390933          	sub	s2,s2,s3
	memset((void *)BASE_ADDRESS + n * MAX_APP_SIZE, 0, MAX_APP_SIZE);
    80200170:	0115151b          	slliw	a0,a0,0x11
    80200174:	20100493          	li	s1,513
    80200178:	04da                	slli	s1,s1,0x16
    8020017a:	94aa                	add	s1,s1,a0
    8020017c:	00020637          	lui	a2,0x20
    80200180:	4581                	li	a1,0
    80200182:	8526                	mv	a0,s1
    80200184:	00000097          	auipc	ra,0x0
    80200188:	6ee080e7          	jalr	1774(ra) # 80200872 <memset>
	memmove((void *)BASE_ADDRESS + n * MAX_APP_SIZE, (void *)start, length);
    8020018c:	0009061b          	sext.w	a2,s2
    80200190:	85ce                	mv	a1,s3
    80200192:	8526                	mv	a0,s1
    80200194:	00000097          	auipc	ra,0x0
    80200198:	73a080e7          	jalr	1850(ra) # 802008ce <memmove>
	return length;
}
    8020019c:	0009051b          	sext.w	a0,s2
    802001a0:	70a2                	ld	ra,40(sp)
    802001a2:	7402                	ld	s0,32(sp)
    802001a4:	64e2                	ld	s1,24(sp)
    802001a6:	6942                	ld	s2,16(sp)
    802001a8:	69a2                	ld	s3,8(sp)
    802001aa:	6145                	addi	sp,sp,48
    802001ac:	8082                	ret

00000000802001ae <run_all_app>:

// load all apps and init the corresponding `proc` structure.
int run_all_app()
{
	for (int i = 0; i < app_num; ++i) {
    802001ae:	0006a797          	auipc	a5,0x6a
    802001b2:	1e27b783          	ld	a5,482(a5) # 8026a390 <app_num>
    802001b6:	c7e9                	beqz	a5,80200280 <run_all_app+0xd2>
{
    802001b8:	7159                	addi	sp,sp,-112
    802001ba:	f486                	sd	ra,104(sp)
    802001bc:	f0a2                	sd	s0,96(sp)
    802001be:	eca6                	sd	s1,88(sp)
    802001c0:	e8ca                	sd	s2,80(sp)
    802001c2:	e4ce                	sd	s3,72(sp)
    802001c4:	e0d2                	sd	s4,64(sp)
    802001c6:	fc56                	sd	s5,56(sp)
    802001c8:	f85a                	sd	s6,48(sp)
    802001ca:	f45e                	sd	s7,40(sp)
    802001cc:	f062                	sd	s8,32(sp)
    802001ce:	ec66                	sd	s9,24(sp)
    802001d0:	e86a                	sd	s10,16(sp)
    802001d2:	e46e                	sd	s11,8(sp)
    802001d4:	1880                	addi	s0,sp,112
	for (int i = 0; i < app_num; ++i) {
    802001d6:	804009b7          	lui	s3,0x80400
    802001da:	4901                	li	s2,0
		struct proc *p = allocproc();
		struct trapframe *trapframe = p->trapframe;
		load_app(i, app_info_ptr);
    802001dc:	0006ad97          	auipc	s11,0x6a
    802001e0:	1acd8d93          	addi	s11,s11,428 # 8026a388 <app_info_ptr>
		uint64 entry = BASE_ADDRESS + i * MAX_APP_SIZE;
		tracef("load app %d at %p", i, entry);
		trapframe->epc = entry;
		trapframe->sp = (uint64)p->ustack + USER_STACK_SIZE;
    802001e4:	6b85                	lui	s7,0x1
		p->state = RUNNABLE;
    802001e6:	4d0d                	li	s10,3
	for (int i = 0; i < app_num; ++i) {
    802001e8:	00020cb7          	lui	s9,0x20
    802001ec:	0006ac17          	auipc	s8,0x6a
    802001f0:	1a4c0c13          	addi	s8,s8,420 # 8026a390 <app_num>
    802001f4:	00090b1b          	sext.w	s6,s2
		struct proc *p = allocproc();
    802001f8:	00000097          	auipc	ra,0x0
    802001fc:	448080e7          	jalr	1096(ra) # 80200640 <allocproc>
    80200200:	84aa                	mv	s1,a0
		struct trapframe *trapframe = p->trapframe;
    80200202:	01853a03          	ld	s4,24(a0)
		load_app(i, app_info_ptr);
    80200206:	000db583          	ld	a1,0(s11)
    8020020a:	855a                	mv	a0,s6
    8020020c:	00000097          	auipc	ra,0x0
    80200210:	f44080e7          	jalr	-188(ra) # 80200150 <load_app>
		uint64 entry = BASE_ADDRESS + i * MAX_APP_SIZE;
    80200214:	02099a93          	slli	s5,s3,0x20
    80200218:	020ada93          	srli	s5,s5,0x20
		tracef("load app %d at %p", i, entry);
    8020021c:	8656                	mv	a2,s5
    8020021e:	85da                	mv	a1,s6
    80200220:	4501                	li	a0,0
    80200222:	00000097          	auipc	ra,0x0
    80200226:	7fe080e7          	jalr	2046(ra) # 80200a20 <dummy>
		trapframe->epc = entry;
    8020022a:	015a3c23          	sd	s5,24(s4)
		trapframe->sp = (uint64)p->ustack + USER_STACK_SIZE;
    8020022e:	649c                	ld	a5,8(s1)
    80200230:	97de                	add	a5,a5,s7
    80200232:	02fa3823          	sd	a5,48(s4)
		p->state = RUNNABLE;
    80200236:	01a4a023          	sw	s10,0(s1)
		/*
		* LAB1: you may need to initialize your new fields of proc here
		*/
		// new fields
		p->first_time = 0;
    8020023a:	0804b823          	sd	zero,144(s1)
		memset(p->syscall_times, 0, sizeof(p->syscall_times));
    8020023e:	6785                	lui	a5,0x1
    80200240:	fa078613          	addi	a2,a5,-96 # fa0 <_entry-0x801ff060>
    80200244:	4581                	li	a1,0
    80200246:	09848513          	addi	a0,s1,152
    8020024a:	00000097          	auipc	ra,0x0
    8020024e:	628080e7          	jalr	1576(ra) # 80200872 <memset>
	for (int i = 0; i < app_num; ++i) {
    80200252:	0905                	addi	s2,s2,1
    80200254:	013c89bb          	addw	s3,s9,s3
    80200258:	000c3783          	ld	a5,0(s8)
    8020025c:	f8f96ce3          	bltu	s2,a5,802001f4 <run_all_app+0x46>
	}
	return 0;
    80200260:	4501                	li	a0,0
    80200262:	70a6                	ld	ra,104(sp)
    80200264:	7406                	ld	s0,96(sp)
    80200266:	64e6                	ld	s1,88(sp)
    80200268:	6946                	ld	s2,80(sp)
    8020026a:	69a6                	ld	s3,72(sp)
    8020026c:	6a06                	ld	s4,64(sp)
    8020026e:	7ae2                	ld	s5,56(sp)
    80200270:	7b42                	ld	s6,48(sp)
    80200272:	7ba2                	ld	s7,40(sp)
    80200274:	7c02                	ld	s8,32(sp)
    80200276:	6ce2                	ld	s9,24(sp)
    80200278:	6d42                	ld	s10,16(sp)
    8020027a:	6da2                	ld	s11,8(sp)
    8020027c:	6165                	addi	sp,sp,112
    8020027e:	8082                	ret
    80200280:	4501                	li	a0,0
    80200282:	8082                	ret

0000000080200284 <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    80200284:	1141                	addi	sp,sp,-16
    80200286:	e406                	sd	ra,8(sp)
    80200288:	e022                	sd	s0,0(sp)
    8020028a:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    8020028c:	00028517          	auipc	a0,0x28
    80200290:	d7450513          	addi	a0,a0,-652 # 80228000 <idle>
    80200294:	0006b617          	auipc	a2,0x6b
    80200298:	d6c60613          	addi	a2,a2,-660 # 8026b000 <e_bss>
    8020029c:	9e09                	subw	a2,a2,a0
    8020029e:	4581                	li	a1,0
    802002a0:	00000097          	auipc	ra,0x0
    802002a4:	5d2080e7          	jalr	1490(ra) # 80200872 <memset>
}
    802002a8:	60a2                	ld	ra,8(sp)
    802002aa:	6402                	ld	s0,0(sp)
    802002ac:	0141                	addi	sp,sp,16
    802002ae:	8082                	ret

00000000802002b0 <main>:

void main()
{
    802002b0:	1141                	addi	sp,sp,-16
    802002b2:	e406                	sd	ra,8(sp)
    802002b4:	e022                	sd	s0,0(sp)
    802002b6:	0800                	addi	s0,sp,16
	clean_bss();
    802002b8:	00000097          	auipc	ra,0x0
    802002bc:	fcc080e7          	jalr	-52(ra) # 80200284 <clean_bss>
	proc_init();
    802002c0:	00000097          	auipc	ra,0x0
    802002c4:	2dc080e7          	jalr	732(ra) # 8020059c <proc_init>
	loader_init();
    802002c8:	00000097          	auipc	ra,0x0
    802002cc:	dd2080e7          	jalr	-558(ra) # 8020009a <loader_init>
	trap_init();
    802002d0:	00001097          	auipc	ra,0x1
    802002d4:	ae8080e7          	jalr	-1304(ra) # 80200db8 <trap_init>
	timer_init();
    802002d8:	00001097          	auipc	ra,0x1
    802002dc:	a00080e7          	jalr	-1536(ra) # 80200cd8 <timer_init>
	run_all_app();
    802002e0:	00000097          	auipc	ra,0x0
    802002e4:	ece080e7          	jalr	-306(ra) # 802001ae <run_all_app>
	infof("start scheduler!");
    802002e8:	4501                	li	a0,0
    802002ea:	00000097          	auipc	ra,0x0
    802002ee:	736080e7          	jalr	1846(ra) # 80200a20 <dummy>
	scheduler();
    802002f2:	00000097          	auipc	ra,0x0
    802002f6:	3d6080e7          	jalr	982(ra) # 802006c8 <scheduler>

00000000802002fa <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802002fa:	7179                	addi	sp,sp,-48
    802002fc:	f406                	sd	ra,40(sp)
    802002fe:	f022                	sd	s0,32(sp)
    80200300:	ec26                	sd	s1,24(sp)
    80200302:	e84a                	sd	s2,16(sp)
    80200304:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    80200306:	c219                	beqz	a2,8020030c <printint+0x12>
    80200308:	08054663          	bltz	a0,80200394 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    8020030c:	2501                	sext.w	a0,a0
    8020030e:	4881                	li	a7,0
    80200310:	fd040693          	addi	a3,s0,-48

	i = 0;
    80200314:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    80200316:	2581                	sext.w	a1,a1
    80200318:	00002617          	auipc	a2,0x2
    8020031c:	d9860613          	addi	a2,a2,-616 # 802020b0 <digits>
    80200320:	883a                	mv	a6,a4
    80200322:	2705                	addiw	a4,a4,1
    80200324:	02b577bb          	remuw	a5,a0,a1
    80200328:	1782                	slli	a5,a5,0x20
    8020032a:	9381                	srli	a5,a5,0x20
    8020032c:	97b2                	add	a5,a5,a2
    8020032e:	0007c783          	lbu	a5,0(a5)
    80200332:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    80200336:	0005079b          	sext.w	a5,a0
    8020033a:	02b5553b          	divuw	a0,a0,a1
    8020033e:	0685                	addi	a3,a3,1
    80200340:	feb7f0e3          	bgeu	a5,a1,80200320 <printint+0x26>

	if (sign)
    80200344:	00088b63          	beqz	a7,8020035a <printint+0x60>
		buf[i++] = '-';
    80200348:	fe040793          	addi	a5,s0,-32
    8020034c:	973e                	add	a4,a4,a5
    8020034e:	02d00793          	li	a5,45
    80200352:	fef70823          	sb	a5,-16(a4)
    80200356:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    8020035a:	02e05763          	blez	a4,80200388 <printint+0x8e>
    8020035e:	fd040793          	addi	a5,s0,-48
    80200362:	00e784b3          	add	s1,a5,a4
    80200366:	fff78913          	addi	s2,a5,-1
    8020036a:	993a                	add	s2,s2,a4
    8020036c:	377d                	addiw	a4,a4,-1
    8020036e:	1702                	slli	a4,a4,0x20
    80200370:	9301                	srli	a4,a4,0x20
    80200372:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    80200376:	fff4c503          	lbu	a0,-1(s1)
    8020037a:	00000097          	auipc	ra,0x0
    8020037e:	c92080e7          	jalr	-878(ra) # 8020000c <consputc>
	while (--i >= 0)
    80200382:	14fd                	addi	s1,s1,-1
    80200384:	ff2499e3          	bne	s1,s2,80200376 <printint+0x7c>
}
    80200388:	70a2                	ld	ra,40(sp)
    8020038a:	7402                	ld	s0,32(sp)
    8020038c:	64e2                	ld	s1,24(sp)
    8020038e:	6942                	ld	s2,16(sp)
    80200390:	6145                	addi	sp,sp,48
    80200392:	8082                	ret
		x = -xx;
    80200394:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    80200398:	4885                	li	a7,1
		x = -xx;
    8020039a:	bf9d                	j	80200310 <printint+0x16>

000000008020039c <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    8020039c:	7131                	addi	sp,sp,-192
    8020039e:	fc86                	sd	ra,120(sp)
    802003a0:	f8a2                	sd	s0,112(sp)
    802003a2:	f4a6                	sd	s1,104(sp)
    802003a4:	f0ca                	sd	s2,96(sp)
    802003a6:	ecce                	sd	s3,88(sp)
    802003a8:	e8d2                	sd	s4,80(sp)
    802003aa:	e4d6                	sd	s5,72(sp)
    802003ac:	e0da                	sd	s6,64(sp)
    802003ae:	fc5e                	sd	s7,56(sp)
    802003b0:	f862                	sd	s8,48(sp)
    802003b2:	f466                	sd	s9,40(sp)
    802003b4:	f06a                	sd	s10,32(sp)
    802003b6:	ec6e                	sd	s11,24(sp)
    802003b8:	0100                	addi	s0,sp,128
    802003ba:	8a2a                	mv	s4,a0
    802003bc:	e40c                	sd	a1,8(s0)
    802003be:	e810                	sd	a2,16(s0)
    802003c0:	ec14                	sd	a3,24(s0)
    802003c2:	f018                	sd	a4,32(s0)
    802003c4:	f41c                	sd	a5,40(s0)
    802003c6:	03043823          	sd	a6,48(s0)
    802003ca:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802003ce:	c915                	beqz	a0,80200402 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    802003d0:	00840793          	addi	a5,s0,8
    802003d4:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802003d8:	000a4503          	lbu	a0,0(s4)
    802003dc:	16050c63          	beqz	a0,80200554 <printf+0x1b8>
    802003e0:	4981                	li	s3,0
		if (c != '%') {
    802003e2:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    802003e6:	07000b93          	li	s7,112
	consputc('x');
    802003ea:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802003ec:	00002b17          	auipc	s6,0x2
    802003f0:	cc4b0b13          	addi	s6,s6,-828 # 802020b0 <digits>
		switch (c) {
    802003f4:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802003f8:	02800d93          	li	s11,40
		switch (c) {
    802003fc:	06400c13          	li	s8,100
    80200400:	a889                	j	80200452 <printf+0xb6>
		panic("null fmt");
    80200402:	00000097          	auipc	ra,0x0
    80200406:	170080e7          	jalr	368(ra) # 80200572 <threadid>
    8020040a:	86aa                	mv	a3,a0
    8020040c:	02e00793          	li	a5,46
    80200410:	00002717          	auipc	a4,0x2
    80200414:	c6870713          	addi	a4,a4,-920 # 80202078 <e_text+0x78>
    80200418:	00002617          	auipc	a2,0x2
    8020041c:	bf860613          	addi	a2,a2,-1032 # 80202010 <e_text+0x10>
    80200420:	45fd                	li	a1,31
    80200422:	00002517          	auipc	a0,0x2
    80200426:	c6650513          	addi	a0,a0,-922 # 80202088 <e_text+0x88>
    8020042a:	00000097          	auipc	ra,0x0
    8020042e:	f72080e7          	jalr	-142(ra) # 8020039c <printf>
    80200432:	00000097          	auipc	ra,0x0
    80200436:	412080e7          	jalr	1042(ra) # 80200844 <shutdown>
    8020043a:	bf59                	j	802003d0 <printf+0x34>
			consputc(c);
    8020043c:	00000097          	auipc	ra,0x0
    80200440:	bd0080e7          	jalr	-1072(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200444:	2985                	addiw	s3,s3,1
    80200446:	013a07b3          	add	a5,s4,s3
    8020044a:	0007c503          	lbu	a0,0(a5)
    8020044e:	10050363          	beqz	a0,80200554 <printf+0x1b8>
		if (c != '%') {
    80200452:	ff5515e3          	bne	a0,s5,8020043c <printf+0xa0>
		c = fmt[++i] & 0xff;
    80200456:	2985                	addiw	s3,s3,1
    80200458:	013a07b3          	add	a5,s4,s3
    8020045c:	0007c783          	lbu	a5,0(a5)
    80200460:	0007849b          	sext.w	s1,a5
		if (c == 0)
    80200464:	cbe5                	beqz	a5,80200554 <printf+0x1b8>
		switch (c) {
    80200466:	05778a63          	beq	a5,s7,802004ba <printf+0x11e>
    8020046a:	02fbf663          	bgeu	s7,a5,80200496 <printf+0xfa>
    8020046e:	09978863          	beq	a5,s9,802004fe <printf+0x162>
    80200472:	07800713          	li	a4,120
    80200476:	0ce79463          	bne	a5,a4,8020053e <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    8020047a:	f8843783          	ld	a5,-120(s0)
    8020047e:	00878713          	addi	a4,a5,8
    80200482:	f8e43423          	sd	a4,-120(s0)
    80200486:	4605                	li	a2,1
    80200488:	85ea                	mv	a1,s10
    8020048a:	4388                	lw	a0,0(a5)
    8020048c:	00000097          	auipc	ra,0x0
    80200490:	e6e080e7          	jalr	-402(ra) # 802002fa <printint>
			break;
    80200494:	bf45                	j	80200444 <printf+0xa8>
		switch (c) {
    80200496:	09578e63          	beq	a5,s5,80200532 <printf+0x196>
    8020049a:	0b879263          	bne	a5,s8,8020053e <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    8020049e:	f8843783          	ld	a5,-120(s0)
    802004a2:	00878713          	addi	a4,a5,8
    802004a6:	f8e43423          	sd	a4,-120(s0)
    802004aa:	4605                	li	a2,1
    802004ac:	45a9                	li	a1,10
    802004ae:	4388                	lw	a0,0(a5)
    802004b0:	00000097          	auipc	ra,0x0
    802004b4:	e4a080e7          	jalr	-438(ra) # 802002fa <printint>
			break;
    802004b8:	b771                	j	80200444 <printf+0xa8>
			printptr(va_arg(ap, uint64));
    802004ba:	f8843783          	ld	a5,-120(s0)
    802004be:	00878713          	addi	a4,a5,8
    802004c2:	f8e43423          	sd	a4,-120(s0)
    802004c6:	0007b903          	ld	s2,0(a5)
	consputc('0');
    802004ca:	03000513          	li	a0,48
    802004ce:	00000097          	auipc	ra,0x0
    802004d2:	b3e080e7          	jalr	-1218(ra) # 8020000c <consputc>
	consputc('x');
    802004d6:	07800513          	li	a0,120
    802004da:	00000097          	auipc	ra,0x0
    802004de:	b32080e7          	jalr	-1230(ra) # 8020000c <consputc>
    802004e2:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802004e4:	03c95793          	srli	a5,s2,0x3c
    802004e8:	97da                	add	a5,a5,s6
    802004ea:	0007c503          	lbu	a0,0(a5)
    802004ee:	00000097          	auipc	ra,0x0
    802004f2:	b1e080e7          	jalr	-1250(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    802004f6:	0912                	slli	s2,s2,0x4
    802004f8:	34fd                	addiw	s1,s1,-1
    802004fa:	f4ed                	bnez	s1,802004e4 <printf+0x148>
    802004fc:	b7a1                	j	80200444 <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    802004fe:	f8843783          	ld	a5,-120(s0)
    80200502:	00878713          	addi	a4,a5,8
    80200506:	f8e43423          	sd	a4,-120(s0)
    8020050a:	6384                	ld	s1,0(a5)
    8020050c:	cc89                	beqz	s1,80200526 <printf+0x18a>
			for (; *s; s++)
    8020050e:	0004c503          	lbu	a0,0(s1)
    80200512:	d90d                	beqz	a0,80200444 <printf+0xa8>
				consputc(*s);
    80200514:	00000097          	auipc	ra,0x0
    80200518:	af8080e7          	jalr	-1288(ra) # 8020000c <consputc>
			for (; *s; s++)
    8020051c:	0485                	addi	s1,s1,1
    8020051e:	0004c503          	lbu	a0,0(s1)
    80200522:	f96d                	bnez	a0,80200514 <printf+0x178>
    80200524:	b705                	j	80200444 <printf+0xa8>
				s = "(null)";
    80200526:	00002497          	auipc	s1,0x2
    8020052a:	b4a48493          	addi	s1,s1,-1206 # 80202070 <e_text+0x70>
			for (; *s; s++)
    8020052e:	856e                	mv	a0,s11
    80200530:	b7d5                	j	80200514 <printf+0x178>
			break;
		case '%':
			consputc('%');
    80200532:	8556                	mv	a0,s5
    80200534:	00000097          	auipc	ra,0x0
    80200538:	ad8080e7          	jalr	-1320(ra) # 8020000c <consputc>
			break;
    8020053c:	b721                	j	80200444 <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020053e:	8556                	mv	a0,s5
    80200540:	00000097          	auipc	ra,0x0
    80200544:	acc080e7          	jalr	-1332(ra) # 8020000c <consputc>
			consputc(c);
    80200548:	8526                	mv	a0,s1
    8020054a:	00000097          	auipc	ra,0x0
    8020054e:	ac2080e7          	jalr	-1342(ra) # 8020000c <consputc>
			break;
    80200552:	bdcd                	j	80200444 <printf+0xa8>
		}
	}
    80200554:	70e6                	ld	ra,120(sp)
    80200556:	7446                	ld	s0,112(sp)
    80200558:	74a6                	ld	s1,104(sp)
    8020055a:	7906                	ld	s2,96(sp)
    8020055c:	69e6                	ld	s3,88(sp)
    8020055e:	6a46                	ld	s4,80(sp)
    80200560:	6aa6                	ld	s5,72(sp)
    80200562:	6b06                	ld	s6,64(sp)
    80200564:	7be2                	ld	s7,56(sp)
    80200566:	7c42                	ld	s8,48(sp)
    80200568:	7ca2                	ld	s9,40(sp)
    8020056a:	7d02                	ld	s10,32(sp)
    8020056c:	6de2                	ld	s11,24(sp)
    8020056e:	6129                	addi	sp,sp,192
    80200570:	8082                	ret

0000000080200572 <threadid>:
extern char boot_stack_top[];
struct proc *current_proc;
struct proc idle;

int threadid()
{
    80200572:	1141                	addi	sp,sp,-16
    80200574:	e422                	sd	s0,8(sp)
    80200576:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    80200578:	0006a797          	auipc	a5,0x6a
    8020057c:	e207b783          	ld	a5,-480(a5) # 8026a398 <current_proc>
    80200580:	43c8                	lw	a0,4(a5)
    80200582:	6422                	ld	s0,8(sp)
    80200584:	0141                	addi	sp,sp,16
    80200586:	8082                	ret

0000000080200588 <curr_proc>:

struct proc *curr_proc()
{
    80200588:	1141                	addi	sp,sp,-16
    8020058a:	e422                	sd	s0,8(sp)
    8020058c:	0800                	addi	s0,sp,16
	return current_proc;
}
    8020058e:	0006a517          	auipc	a0,0x6a
    80200592:	e0a53503          	ld	a0,-502(a0) # 8026a398 <current_proc>
    80200596:	6422                	ld	s0,8(sp)
    80200598:	0141                	addi	sp,sp,16
    8020059a:	8082                	ret

000000008020059c <proc_init>:

// initialize the proc table at boot time.
void proc_init(void)
{
    8020059c:	1141                	addi	sp,sp,-16
    8020059e:	e422                	sd	s0,8(sp)
    802005a0:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    802005a2:	0005a717          	auipc	a4,0x5a
    802005a6:	a5e70713          	addi	a4,a4,-1442 # 8025a000 <pool>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    802005aa:	8e3a                	mv	t3,a4
    802005ac:	00002317          	auipc	t1,0x2
    802005b0:	d2c33303          	ld	t1,-724(t1) # 802022d8 <digits+0x228>
    802005b4:	0004a897          	auipc	a7,0x4a
    802005b8:	a4c88893          	addi	a7,a7,-1460 # 8024a000 <kstack>
		p->ustack = (uint64)ustack[p - pool];
    802005bc:	0003a817          	auipc	a6,0x3a
    802005c0:	a4480813          	addi	a6,a6,-1468 # 8023a000 <ustack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802005c4:	0002a517          	auipc	a0,0x2a
    802005c8:	a3c50513          	addi	a0,a0,-1476 # 8022a000 <trapframe>
	for (p = pool; p < &pool[NPROC]; p++) {
    802005cc:	6605                	lui	a2,0x1
    802005ce:	03860613          	addi	a2,a2,56 # 1038 <_entry-0x801fefc8>
    802005d2:	0006a597          	auipc	a1,0x6a
    802005d6:	dae58593          	addi	a1,a1,-594 # 8026a380 <fin.0>
		p->state = UNUSED;
    802005da:	00072023          	sw	zero,0(a4)
		p->kstack = (uint64)kstack[p - pool];
    802005de:	41c707b3          	sub	a5,a4,t3
    802005e2:	878d                	srai	a5,a5,0x3
    802005e4:	026787b3          	mul	a5,a5,t1
    802005e8:	07b2                	slli	a5,a5,0xc
    802005ea:	011786b3          	add	a3,a5,a7
    802005ee:	eb14                	sd	a3,16(a4)
		p->ustack = (uint64)ustack[p - pool];
    802005f0:	010786b3          	add	a3,a5,a6
    802005f4:	e714                	sd	a3,8(a4)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802005f6:	97aa                	add	a5,a5,a0
    802005f8:	ef1c                	sd	a5,24(a4)
	for (p = pool; p < &pool[NPROC]; p++) {
    802005fa:	9732                	add	a4,a4,a2
    802005fc:	fcb71fe3          	bne	a4,a1,802005da <proc_init+0x3e>
		/*
		* LAB1: you may need to initialize your new fields of proc here
		*/
	}
	idle.kstack = (uint64)boot_stack_top;
    80200600:	00028797          	auipc	a5,0x28
    80200604:	a0078793          	addi	a5,a5,-1536 # 80228000 <idle>
    80200608:	00028717          	auipc	a4,0x28
    8020060c:	9f870713          	addi	a4,a4,-1544 # 80228000 <idle>
    80200610:	eb98                	sd	a4,16(a5)
	idle.pid = 0;
    80200612:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    80200616:	0006a717          	auipc	a4,0x6a
    8020061a:	d8f73123          	sd	a5,-638(a4) # 8026a398 <current_proc>
}
    8020061e:	6422                	ld	s0,8(sp)
    80200620:	0141                	addi	sp,sp,16
    80200622:	8082                	ret

0000000080200624 <allocpid>:

int allocpid()
{
    80200624:	1141                	addi	sp,sp,-16
    80200626:	e422                	sd	s0,8(sp)
    80200628:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    8020062a:	00017797          	auipc	a5,0x17
    8020062e:	9d678793          	addi	a5,a5,-1578 # 80217000 <PID.0>
    80200632:	4388                	lw	a0,0(a5)
    80200634:	0015071b          	addiw	a4,a0,1
    80200638:	c398                	sw	a4,0(a5)
}
    8020063a:	6422                	ld	s0,8(sp)
    8020063c:	0141                	addi	sp,sp,16
    8020063e:	8082                	ret

0000000080200640 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc(void)
{
    80200640:	1101                	addi	sp,sp,-32
    80200642:	ec06                	sd	ra,24(sp)
    80200644:	e822                	sd	s0,16(sp)
    80200646:	e426                	sd	s1,8(sp)
    80200648:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    8020064a:	0005a497          	auipc	s1,0x5a
    8020064e:	9b648493          	addi	s1,s1,-1610 # 8025a000 <pool>
    80200652:	6705                	lui	a4,0x1
    80200654:	03870713          	addi	a4,a4,56 # 1038 <_entry-0x801fefc8>
    80200658:	0006a697          	auipc	a3,0x6a
    8020065c:	d2868693          	addi	a3,a3,-728 # 8026a380 <fin.0>
		if (p->state == UNUSED) {
    80200660:	409c                	lw	a5,0(s1)
    80200662:	cb99                	beqz	a5,80200678 <allocproc+0x38>
	for (p = pool; p < &pool[NPROC]; p++) {
    80200664:	94ba                	add	s1,s1,a4
    80200666:	fed49de3          	bne	s1,a3,80200660 <allocproc+0x20>
			goto found;
		}
	}
	return 0;
    8020066a:	4481                	li	s1,0
	

	p->context.ra = (uint64)usertrapret;
	p->context.sp = p->kstack + PAGE_SIZE;
	return p;
}
    8020066c:	8526                	mv	a0,s1
    8020066e:	60e2                	ld	ra,24(sp)
    80200670:	6442                	ld	s0,16(sp)
    80200672:	64a2                	ld	s1,8(sp)
    80200674:	6105                	addi	sp,sp,32
    80200676:	8082                	ret
	p->pid = allocpid();
    80200678:	00000097          	auipc	ra,0x0
    8020067c:	fac080e7          	jalr	-84(ra) # 80200624 <allocpid>
    80200680:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    80200682:	4785                	li	a5,1
    80200684:	c09c                	sw	a5,0(s1)
	memset(&p->context, 0, sizeof(p->context));
    80200686:	07000613          	li	a2,112
    8020068a:	4581                	li	a1,0
    8020068c:	02048513          	addi	a0,s1,32
    80200690:	00000097          	auipc	ra,0x0
    80200694:	1e2080e7          	jalr	482(ra) # 80200872 <memset>
	memset(p->trapframe, 0, PAGE_SIZE);
    80200698:	6605                	lui	a2,0x1
    8020069a:	4581                	li	a1,0
    8020069c:	6c88                	ld	a0,24(s1)
    8020069e:	00000097          	auipc	ra,0x0
    802006a2:	1d4080e7          	jalr	468(ra) # 80200872 <memset>
	memset((void *)p->kstack, 0, PAGE_SIZE);
    802006a6:	6605                	lui	a2,0x1
    802006a8:	4581                	li	a1,0
    802006aa:	6888                	ld	a0,16(s1)
    802006ac:	00000097          	auipc	ra,0x0
    802006b0:	1c6080e7          	jalr	454(ra) # 80200872 <memset>
	p->context.ra = (uint64)usertrapret;
    802006b4:	00000797          	auipc	a5,0x0
    802006b8:	76478793          	addi	a5,a5,1892 # 80200e18 <usertrapret>
    802006bc:	f09c                	sd	a5,32(s1)
	p->context.sp = p->kstack + PAGE_SIZE;
    802006be:	689c                	ld	a5,16(s1)
    802006c0:	6705                	lui	a4,0x1
    802006c2:	97ba                	add	a5,a5,a4
    802006c4:	f49c                	sd	a5,40(s1)
	return p;
    802006c6:	b75d                	j	8020066c <allocproc+0x2c>

00000000802006c8 <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler(void)
{
    802006c8:	715d                	addi	sp,sp,-80
    802006ca:	e486                	sd	ra,72(sp)
    802006cc:	e0a2                	sd	s0,64(sp)
    802006ce:	fc26                	sd	s1,56(sp)
    802006d0:	f84a                	sd	s2,48(sp)
    802006d2:	f44e                	sd	s3,40(sp)
    802006d4:	f052                	sd	s4,32(sp)
    802006d6:	ec56                	sd	s5,24(sp)
    802006d8:	e85a                	sd	s6,16(sp)
    802006da:	e45e                	sd	s7,8(sp)
    802006dc:	e062                	sd	s8,0(sp)
    802006de:	0880                	addi	s0,sp,80
				*/
				if (p->first_time == 0) {
        			p->first_time = get_cycle() / (CPU_FREQ / 1000);
    			}
				p->state = RUNNING;
				current_proc = p;
    802006e0:	0006ab97          	auipc	s7,0x6a
    802006e4:	cb8b8b93          	addi	s7,s7,-840 # 8026a398 <current_proc>
				swtch(&idle.context, &p->context);
    802006e8:	00028b17          	auipc	s6,0x28
    802006ec:	938b0b13          	addi	s6,s6,-1736 # 80228020 <idle+0x20>
        			p->first_time = get_cycle() / (CPU_FREQ / 1000);
    802006f0:	6c0d                	lui	s8,0x3
    802006f2:	0d4c0c13          	addi	s8,s8,212 # 30d4 <_entry-0x801fcf2c>
		for (p = pool; p < &pool[NPROC]; p++) {
    802006f6:	6985                	lui	s3,0x1
    802006f8:	03898993          	addi	s3,s3,56 # 1038 <_entry-0x801fefc8>
    802006fc:	0006aa17          	auipc	s4,0x6a
    80200700:	c84a0a13          	addi	s4,s4,-892 # 8026a380 <fin.0>
    80200704:	0005a497          	auipc	s1,0x5a
    80200708:	8fc48493          	addi	s1,s1,-1796 # 8025a000 <pool>
			if (p->state == RUNNABLE) {
    8020070c:	490d                	li	s2,3
				p->state = RUNNING;
    8020070e:	4a91                	li	s5,4
    80200710:	a839                	j	8020072e <scheduler+0x66>
    80200712:	0154a023          	sw	s5,0(s1)
				current_proc = p;
    80200716:	009bb023          	sd	s1,0(s7)
				swtch(&idle.context, &p->context);
    8020071a:	02048593          	addi	a1,s1,32
    8020071e:	855a                	mv	a0,s6
    80200720:	00001097          	auipc	ra,0x1
    80200724:	888080e7          	jalr	-1912(ra) # 80200fa8 <swtch>
		for (p = pool; p < &pool[NPROC]; p++) {
    80200728:	94ce                	add	s1,s1,s3
    8020072a:	fd448de3          	beq	s1,s4,80200704 <scheduler+0x3c>
			if (p->state == RUNNABLE) {
    8020072e:	409c                	lw	a5,0(s1)
    80200730:	ff279ce3          	bne	a5,s2,80200728 <scheduler+0x60>
				if (p->first_time == 0) {
    80200734:	68dc                	ld	a5,144(s1)
    80200736:	fff1                	bnez	a5,80200712 <scheduler+0x4a>
        			p->first_time = get_cycle() / (CPU_FREQ / 1000);
    80200738:	00000097          	auipc	ra,0x0
    8020073c:	56c080e7          	jalr	1388(ra) # 80200ca4 <get_cycle>
    80200740:	03855533          	divu	a0,a0,s8
    80200744:	e8c8                	sd	a0,144(s1)
    80200746:	b7f1                	j	80200712 <scheduler+0x4a>

0000000080200748 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
    80200748:	1101                	addi	sp,sp,-32
    8020074a:	ec06                	sd	ra,24(sp)
    8020074c:	e822                	sd	s0,16(sp)
    8020074e:	e426                	sd	s1,8(sp)
    80200750:	1000                	addi	s0,sp,32
	return current_proc;
    80200752:	0006a497          	auipc	s1,0x6a
    80200756:	c464b483          	ld	s1,-954(s1) # 8026a398 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    8020075a:	4098                	lw	a4,0(s1)
    8020075c:	4791                	li	a5,4
    8020075e:	02f70163          	beq	a4,a5,80200780 <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    80200762:	00028597          	auipc	a1,0x28
    80200766:	8be58593          	addi	a1,a1,-1858 # 80228020 <idle+0x20>
    8020076a:	02048513          	addi	a0,s1,32
    8020076e:	00001097          	auipc	ra,0x1
    80200772:	83a080e7          	jalr	-1990(ra) # 80200fa8 <swtch>
}
    80200776:	60e2                	ld	ra,24(sp)
    80200778:	6442                	ld	s0,16(sp)
    8020077a:	64a2                	ld	s1,8(sp)
    8020077c:	6105                	addi	sp,sp,32
    8020077e:	8082                	ret
		panic("sched running");
    80200780:	07000793          	li	a5,112
    80200784:	00002717          	auipc	a4,0x2
    80200788:	94470713          	addi	a4,a4,-1724 # 802020c8 <digits+0x18>
    8020078c:	40d4                	lw	a3,4(s1)
    8020078e:	00002617          	auipc	a2,0x2
    80200792:	88260613          	addi	a2,a2,-1918 # 80202010 <e_text+0x10>
    80200796:	45fd                	li	a1,31
    80200798:	00002517          	auipc	a0,0x2
    8020079c:	94050513          	addi	a0,a0,-1728 # 802020d8 <digits+0x28>
    802007a0:	00000097          	auipc	ra,0x0
    802007a4:	bfc080e7          	jalr	-1028(ra) # 8020039c <printf>
    802007a8:	00000097          	auipc	ra,0x0
    802007ac:	09c080e7          	jalr	156(ra) # 80200844 <shutdown>
    802007b0:	bf4d                	j	80200762 <sched+0x1a>

00000000802007b2 <yield>:

// Give up the CPU for one scheduling round.
void yield(void)
{
    802007b2:	1141                	addi	sp,sp,-16
    802007b4:	e406                	sd	ra,8(sp)
    802007b6:	e022                	sd	s0,0(sp)
    802007b8:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    802007ba:	0006a797          	auipc	a5,0x6a
    802007be:	bde7b783          	ld	a5,-1058(a5) # 8026a398 <current_proc>
    802007c2:	470d                	li	a4,3
    802007c4:	c398                	sw	a4,0(a5)
	sched();
    802007c6:	00000097          	auipc	ra,0x0
    802007ca:	f82080e7          	jalr	-126(ra) # 80200748 <sched>
}
    802007ce:	60a2                	ld	ra,8(sp)
    802007d0:	6402                	ld	s0,0(sp)
    802007d2:	0141                	addi	sp,sp,16
    802007d4:	8082                	ret

00000000802007d6 <exit>:

// Exit the current process.
void exit(int code)
{
    802007d6:	1101                	addi	sp,sp,-32
    802007d8:	ec06                	sd	ra,24(sp)
    802007da:	e822                	sd	s0,16(sp)
    802007dc:	e426                	sd	s1,8(sp)
    802007de:	1000                	addi	s0,sp,32
    802007e0:	862a                	mv	a2,a0
	return current_proc;
    802007e2:	0006a497          	auipc	s1,0x6a
    802007e6:	bb64b483          	ld	s1,-1098(s1) # 8026a398 <current_proc>
	struct proc *p = curr_proc();
	infof("proc %d exit with %d", p->pid, code);
    802007ea:	40cc                	lw	a1,4(s1)
    802007ec:	4501                	li	a0,0
    802007ee:	00000097          	auipc	ra,0x0
    802007f2:	232080e7          	jalr	562(ra) # 80200a20 <dummy>
	p->state = UNUSED;
    802007f6:	0004a023          	sw	zero,0(s1)
	finished();
    802007fa:	00000097          	auipc	ra,0x0
    802007fe:	836080e7          	jalr	-1994(ra) # 80200030 <finished>
	sched();
    80200802:	00000097          	auipc	ra,0x0
    80200806:	f46080e7          	jalr	-186(ra) # 80200748 <sched>
}
    8020080a:	60e2                	ld	ra,24(sp)
    8020080c:	6442                	ld	s0,16(sp)
    8020080e:	64a2                	ld	s1,8(sp)
    80200810:	6105                	addi	sp,sp,32
    80200812:	8082                	ret

0000000080200814 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    80200814:	1141                	addi	sp,sp,-16
    80200816:	e422                	sd	s0,8(sp)
    80200818:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    8020081a:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    8020081c:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    8020081e:	4885                	li	a7,1
	asm volatile("ecall"
    80200820:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80200824:	6422                	ld	s0,8(sp)
    80200826:	0141                	addi	sp,sp,16
    80200828:	8082                	ret

000000008020082a <console_getchar>:

int console_getchar()
{
    8020082a:	1141                	addi	sp,sp,-16
    8020082c:	e422                	sd	s0,8(sp)
    8020082e:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    80200830:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    80200832:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200834:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200836:	4889                	li	a7,2
	asm volatile("ecall"
    80200838:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    8020083c:	2501                	sext.w	a0,a0
    8020083e:	6422                	ld	s0,8(sp)
    80200840:	0141                	addi	sp,sp,16
    80200842:	8082                	ret

0000000080200844 <shutdown>:

void shutdown()
{
    80200844:	1141                	addi	sp,sp,-16
    80200846:	e422                	sd	s0,8(sp)
    80200848:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    8020084a:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    8020084c:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    8020084e:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200850:	48a1                	li	a7,8
	asm volatile("ecall"
    80200852:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    80200856:	6422                	ld	s0,8(sp)
    80200858:	0141                	addi	sp,sp,16
    8020085a:	8082                	ret

000000008020085c <set_timer>:

void set_timer(uint64 stime)
{
    8020085c:	1141                	addi	sp,sp,-16
    8020085e:	e422                	sd	s0,8(sp)
    80200860:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80200862:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200864:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200866:	4881                	li	a7,0
	asm volatile("ecall"
    80200868:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    8020086c:	6422                	ld	s0,8(sp)
    8020086e:	0141                	addi	sp,sp,16
    80200870:	8082                	ret

0000000080200872 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    80200872:	1141                	addi	sp,sp,-16
    80200874:	e422                	sd	s0,8(sp)
    80200876:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    80200878:	ca19                	beqz	a2,8020088e <memset+0x1c>
    8020087a:	87aa                	mv	a5,a0
    8020087c:	1602                	slli	a2,a2,0x20
    8020087e:	9201                	srli	a2,a2,0x20
    80200880:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    80200884:	00b78023          	sb	a1,0(a5)
	for (i = 0; i < n; i++) {
    80200888:	0785                	addi	a5,a5,1
    8020088a:	fee79de3          	bne	a5,a4,80200884 <memset+0x12>
	}
	return dst;
}
    8020088e:	6422                	ld	s0,8(sp)
    80200890:	0141                	addi	sp,sp,16
    80200892:	8082                	ret

0000000080200894 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80200894:	1141                	addi	sp,sp,-16
    80200896:	e422                	sd	s0,8(sp)
    80200898:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    8020089a:	ca05                	beqz	a2,802008ca <memcmp+0x36>
    8020089c:	fff6069b          	addiw	a3,a2,-1
    802008a0:	1682                	slli	a3,a3,0x20
    802008a2:	9281                	srli	a3,a3,0x20
    802008a4:	0685                	addi	a3,a3,1
    802008a6:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    802008a8:	00054783          	lbu	a5,0(a0)
    802008ac:	0005c703          	lbu	a4,0(a1)
    802008b0:	00e79863          	bne	a5,a4,802008c0 <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    802008b4:	0505                	addi	a0,a0,1
    802008b6:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    802008b8:	fed518e3          	bne	a0,a3,802008a8 <memcmp+0x14>
	}

	return 0;
    802008bc:	4501                	li	a0,0
    802008be:	a019                	j	802008c4 <memcmp+0x30>
			return *s1 - *s2;
    802008c0:	40e7853b          	subw	a0,a5,a4
}
    802008c4:	6422                	ld	s0,8(sp)
    802008c6:	0141                	addi	sp,sp,16
    802008c8:	8082                	ret
	return 0;
    802008ca:	4501                	li	a0,0
    802008cc:	bfe5                	j	802008c4 <memcmp+0x30>

00000000802008ce <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    802008ce:	1141                	addi	sp,sp,-16
    802008d0:	e422                	sd	s0,8(sp)
    802008d2:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    802008d4:	02a5e563          	bltu	a1,a0,802008fe <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    802008d8:	fff6069b          	addiw	a3,a2,-1
    802008dc:	ce11                	beqz	a2,802008f8 <memmove+0x2a>
    802008de:	1682                	slli	a3,a3,0x20
    802008e0:	9281                	srli	a3,a3,0x20
    802008e2:	0685                	addi	a3,a3,1
    802008e4:	96ae                	add	a3,a3,a1
    802008e6:	87aa                	mv	a5,a0
			*d++ = *s++;
    802008e8:	0585                	addi	a1,a1,1
    802008ea:	0785                	addi	a5,a5,1
    802008ec:	fff5c703          	lbu	a4,-1(a1)
    802008f0:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    802008f4:	fed59ae3          	bne	a1,a3,802008e8 <memmove+0x1a>

	return dst;
}
    802008f8:	6422                	ld	s0,8(sp)
    802008fa:	0141                	addi	sp,sp,16
    802008fc:	8082                	ret
	if (s < d && s + n > d) {
    802008fe:	02061713          	slli	a4,a2,0x20
    80200902:	9301                	srli	a4,a4,0x20
    80200904:	00e587b3          	add	a5,a1,a4
    80200908:	fcf578e3          	bgeu	a0,a5,802008d8 <memmove+0xa>
		d += n;
    8020090c:	972a                	add	a4,a4,a0
		while (n-- > 0)
    8020090e:	fff6069b          	addiw	a3,a2,-1
    80200912:	d27d                	beqz	a2,802008f8 <memmove+0x2a>
    80200914:	02069613          	slli	a2,a3,0x20
    80200918:	9201                	srli	a2,a2,0x20
    8020091a:	fff64613          	not	a2,a2
    8020091e:	963e                	add	a2,a2,a5
			*--d = *--s;
    80200920:	17fd                	addi	a5,a5,-1
    80200922:	177d                	addi	a4,a4,-1
    80200924:	0007c683          	lbu	a3,0(a5)
    80200928:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    8020092c:	fef61ae3          	bne	a2,a5,80200920 <memmove+0x52>
    80200930:	b7e1                	j	802008f8 <memmove+0x2a>

0000000080200932 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    80200932:	1141                	addi	sp,sp,-16
    80200934:	e406                	sd	ra,8(sp)
    80200936:	e022                	sd	s0,0(sp)
    80200938:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    8020093a:	00000097          	auipc	ra,0x0
    8020093e:	f94080e7          	jalr	-108(ra) # 802008ce <memmove>
}
    80200942:	60a2                	ld	ra,8(sp)
    80200944:	6402                	ld	s0,0(sp)
    80200946:	0141                	addi	sp,sp,16
    80200948:	8082                	ret

000000008020094a <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    8020094a:	1141                	addi	sp,sp,-16
    8020094c:	e422                	sd	s0,8(sp)
    8020094e:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    80200950:	ce11                	beqz	a2,8020096c <strncmp+0x22>
    80200952:	00054783          	lbu	a5,0(a0)
    80200956:	cf89                	beqz	a5,80200970 <strncmp+0x26>
    80200958:	0005c703          	lbu	a4,0(a1)
    8020095c:	00f71a63          	bne	a4,a5,80200970 <strncmp+0x26>
		n--, p++, q++;
    80200960:	367d                	addiw	a2,a2,-1
    80200962:	0505                	addi	a0,a0,1
    80200964:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    80200966:	f675                	bnez	a2,80200952 <strncmp+0x8>
	if (n == 0)
		return 0;
    80200968:	4501                	li	a0,0
    8020096a:	a809                	j	8020097c <strncmp+0x32>
    8020096c:	4501                	li	a0,0
    8020096e:	a039                	j	8020097c <strncmp+0x32>
	if (n == 0)
    80200970:	ca09                	beqz	a2,80200982 <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    80200972:	00054503          	lbu	a0,0(a0)
    80200976:	0005c783          	lbu	a5,0(a1)
    8020097a:	9d1d                	subw	a0,a0,a5
}
    8020097c:	6422                	ld	s0,8(sp)
    8020097e:	0141                	addi	sp,sp,16
    80200980:	8082                	ret
		return 0;
    80200982:	4501                	li	a0,0
    80200984:	bfe5                	j	8020097c <strncmp+0x32>

0000000080200986 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80200986:	1141                	addi	sp,sp,-16
    80200988:	e422                	sd	s0,8(sp)
    8020098a:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    8020098c:	872a                	mv	a4,a0
    8020098e:	8832                	mv	a6,a2
    80200990:	367d                	addiw	a2,a2,-1
    80200992:	01005963          	blez	a6,802009a4 <strncpy+0x1e>
    80200996:	0705                	addi	a4,a4,1
    80200998:	0005c783          	lbu	a5,0(a1)
    8020099c:	fef70fa3          	sb	a5,-1(a4)
    802009a0:	0585                	addi	a1,a1,1
    802009a2:	f7f5                	bnez	a5,8020098e <strncpy+0x8>
		;
	while (n-- > 0)
    802009a4:	86ba                	mv	a3,a4
    802009a6:	00c05c63          	blez	a2,802009be <strncpy+0x38>
		*s++ = 0;
    802009aa:	0685                	addi	a3,a3,1
    802009ac:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    802009b0:	fff6c793          	not	a5,a3
    802009b4:	9fb9                	addw	a5,a5,a4
    802009b6:	010787bb          	addw	a5,a5,a6
    802009ba:	fef048e3          	bgtz	a5,802009aa <strncpy+0x24>
	return os;
}
    802009be:	6422                	ld	s0,8(sp)
    802009c0:	0141                	addi	sp,sp,16
    802009c2:	8082                	ret

00000000802009c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    802009c4:	1141                	addi	sp,sp,-16
    802009c6:	e422                	sd	s0,8(sp)
    802009c8:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    802009ca:	02c05363          	blez	a2,802009f0 <safestrcpy+0x2c>
    802009ce:	fff6069b          	addiw	a3,a2,-1
    802009d2:	1682                	slli	a3,a3,0x20
    802009d4:	9281                	srli	a3,a3,0x20
    802009d6:	96ae                	add	a3,a3,a1
    802009d8:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    802009da:	00d58963          	beq	a1,a3,802009ec <safestrcpy+0x28>
    802009de:	0585                	addi	a1,a1,1
    802009e0:	0785                	addi	a5,a5,1
    802009e2:	fff5c703          	lbu	a4,-1(a1)
    802009e6:	fee78fa3          	sb	a4,-1(a5)
    802009ea:	fb65                	bnez	a4,802009da <safestrcpy+0x16>
		;
	*s = 0;
    802009ec:	00078023          	sb	zero,0(a5)
	return os;
}
    802009f0:	6422                	ld	s0,8(sp)
    802009f2:	0141                	addi	sp,sp,16
    802009f4:	8082                	ret

00000000802009f6 <strlen>:

int strlen(const char *s)
{
    802009f6:	1141                	addi	sp,sp,-16
    802009f8:	e422                	sd	s0,8(sp)
    802009fa:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    802009fc:	00054783          	lbu	a5,0(a0)
    80200a00:	cf91                	beqz	a5,80200a1c <strlen+0x26>
    80200a02:	0505                	addi	a0,a0,1
    80200a04:	87aa                	mv	a5,a0
    80200a06:	4685                	li	a3,1
    80200a08:	9e89                	subw	a3,a3,a0
    80200a0a:	00f6853b          	addw	a0,a3,a5
    80200a0e:	0785                	addi	a5,a5,1
    80200a10:	fff7c703          	lbu	a4,-1(a5)
    80200a14:	fb7d                	bnez	a4,80200a0a <strlen+0x14>
		;
	return n;
}
    80200a16:	6422                	ld	s0,8(sp)
    80200a18:	0141                	addi	sp,sp,16
    80200a1a:	8082                	ret
	for (n = 0; s[n]; n++)
    80200a1c:	4501                	li	a0,0
    80200a1e:	bfe5                	j	80200a16 <strlen+0x20>

0000000080200a20 <dummy>:

void dummy(int _, ...)
{
    80200a20:	715d                	addi	sp,sp,-80
    80200a22:	e422                	sd	s0,8(sp)
    80200a24:	0800                	addi	s0,sp,16
    80200a26:	e40c                	sd	a1,8(s0)
    80200a28:	e810                	sd	a2,16(s0)
    80200a2a:	ec14                	sd	a3,24(s0)
    80200a2c:	f018                	sd	a4,32(s0)
    80200a2e:	f41c                	sd	a5,40(s0)
    80200a30:	03043823          	sd	a6,48(s0)
    80200a34:	03143c23          	sd	a7,56(s0)
    80200a38:	6422                	ld	s0,8(sp)
    80200a3a:	6161                	addi	sp,sp,80
    80200a3c:	8082                	ret

0000000080200a3e <sys_write>:
#include "timer.h"
#include "trap.h"
#include "proc.h"

uint64 sys_write(int fd, char *str, uint len)
{
    80200a3e:	7179                	addi	sp,sp,-48
    80200a40:	f406                	sd	ra,40(sp)
    80200a42:	f022                	sd	s0,32(sp)
    80200a44:	ec26                	sd	s1,24(sp)
    80200a46:	e84a                	sd	s2,16(sp)
    80200a48:	e44e                	sd	s3,8(sp)
    80200a4a:	1800                	addi	s0,sp,48
    80200a4c:	84aa                	mv	s1,a0
    80200a4e:	892e                	mv	s2,a1
    80200a50:	89b2                	mv	s3,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, str, len);
    80200a52:	86b2                	mv	a3,a2
    80200a54:	862e                	mv	a2,a1
    80200a56:	85aa                	mv	a1,a0
    80200a58:	4501                	li	a0,0
    80200a5a:	00000097          	auipc	ra,0x0
    80200a5e:	fc6080e7          	jalr	-58(ra) # 80200a20 <dummy>
	if (fd != STDOUT)
    80200a62:	4785                	li	a5,1
		return -1;
    80200a64:	557d                	li	a0,-1
	if (fd != STDOUT)
    80200a66:	02f49763          	bne	s1,a5,80200a94 <sys_write+0x56>
	for (int i = 0; i < len; ++i) {
    80200a6a:	02098263          	beqz	s3,80200a8e <sys_write+0x50>
    80200a6e:	84ca                	mv	s1,s2
    80200a70:	fff9859b          	addiw	a1,s3,-1
    80200a74:	1582                	slli	a1,a1,0x20
    80200a76:	9181                	srli	a1,a1,0x20
    80200a78:	992e                	add	s2,s2,a1
		console_putchar(str[i]);
    80200a7a:	0004c503          	lbu	a0,0(s1)
    80200a7e:	00000097          	auipc	ra,0x0
    80200a82:	d96080e7          	jalr	-618(ra) # 80200814 <console_putchar>
	for (int i = 0; i < len; ++i) {
    80200a86:	87a6                	mv	a5,s1
    80200a88:	0485                	addi	s1,s1,1
    80200a8a:	ff2798e3          	bne	a5,s2,80200a7a <sys_write+0x3c>
	}
	return len;
    80200a8e:	02099513          	slli	a0,s3,0x20
    80200a92:	9101                	srli	a0,a0,0x20
}
    80200a94:	70a2                	ld	ra,40(sp)
    80200a96:	7402                	ld	s0,32(sp)
    80200a98:	64e2                	ld	s1,24(sp)
    80200a9a:	6942                	ld	s2,16(sp)
    80200a9c:	69a2                	ld	s3,8(sp)
    80200a9e:	6145                	addi	sp,sp,48
    80200aa0:	8082                	ret

0000000080200aa2 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80200aa2:	1141                	addi	sp,sp,-16
    80200aa4:	e406                	sd	ra,8(sp)
    80200aa6:	e022                	sd	s0,0(sp)
    80200aa8:	0800                	addi	s0,sp,16
	exit(code);
    80200aaa:	00000097          	auipc	ra,0x0
    80200aae:	d2c080e7          	jalr	-724(ra) # 802007d6 <exit>

0000000080200ab2 <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    80200ab2:	1141                	addi	sp,sp,-16
    80200ab4:	e406                	sd	ra,8(sp)
    80200ab6:	e022                	sd	s0,0(sp)
    80200ab8:	0800                	addi	s0,sp,16
	yield();
    80200aba:	00000097          	auipc	ra,0x0
    80200abe:	cf8080e7          	jalr	-776(ra) # 802007b2 <yield>
	return 0;
}
    80200ac2:	4501                	li	a0,0
    80200ac4:	60a2                	ld	ra,8(sp)
    80200ac6:	6402                	ld	s0,0(sp)
    80200ac8:	0141                	addi	sp,sp,16
    80200aca:	8082                	ret

0000000080200acc <sys_gettimeofday>:

uint64 sys_gettimeofday(TimeVal *val, int _tz)
{
    80200acc:	1101                	addi	sp,sp,-32
    80200ace:	ec06                	sd	ra,24(sp)
    80200ad0:	e822                	sd	s0,16(sp)
    80200ad2:	e426                	sd	s1,8(sp)
    80200ad4:	1000                	addi	s0,sp,32
    80200ad6:	84aa                	mv	s1,a0
	uint64 cycle = get_cycle();
    80200ad8:	00000097          	auipc	ra,0x0
    80200adc:	1cc080e7          	jalr	460(ra) # 80200ca4 <get_cycle>
	val->sec = cycle / CPU_FREQ;
    80200ae0:	00bec7b7          	lui	a5,0xbec
    80200ae4:	c2078713          	addi	a4,a5,-992 # bebc20 <_entry-0x7f6143e0>
    80200ae8:	02e557b3          	divu	a5,a0,a4
    80200aec:	e09c                	sd	a5,0(s1)
	val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    80200aee:	02e577b3          	remu	a5,a0,a4
    80200af2:	000f4537          	lui	a0,0xf4
    80200af6:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    80200afa:	02a787b3          	mul	a5,a5,a0
    80200afe:	02e7d7b3          	divu	a5,a5,a4
    80200b02:	e49c                	sd	a5,8(s1)
	return 0;
}
    80200b04:	4501                	li	a0,0
    80200b06:	60e2                	ld	ra,24(sp)
    80200b08:	6442                	ld	s0,16(sp)
    80200b0a:	64a2                	ld	s1,8(sp)
    80200b0c:	6105                	addi	sp,sp,32
    80200b0e:	8082                	ret

0000000080200b10 <sys_task_info>:

/*
* LAB1: you may need to define sys_task_info here
*/
uint64 sys_task_info(struct TaskInfo *ti){
    80200b10:	1101                	addi	sp,sp,-32
    80200b12:	ec06                	sd	ra,24(sp)
    80200b14:	e822                	sd	s0,16(sp)
    80200b16:	e426                	sd	s1,8(sp)
    80200b18:	e04a                	sd	s2,0(sp)
    80200b1a:	1000                	addi	s0,sp,32
    80200b1c:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    80200b1e:	00000097          	auipc	ra,0x0
    80200b22:	a6a080e7          	jalr	-1430(ra) # 80200588 <curr_proc>
    80200b26:	892a                	mv	s2,a0
	ti->status = Running;
    80200b28:	4789                	li	a5,2
    80200b2a:	c09c                	sw	a5,0(s1)
	uint64 now = get_cycle() / (CPU_FREQ/1000);
    80200b2c:	00000097          	auipc	ra,0x0
    80200b30:	178080e7          	jalr	376(ra) # 80200ca4 <get_cycle>
    80200b34:	678d                	lui	a5,0x3
    80200b36:	0d478793          	addi	a5,a5,212 # 30d4 <_entry-0x801fcf2c>
    80200b3a:	02f557b3          	divu	a5,a0,a5
	ti->time = (int)(now - p->first_time);
    80200b3e:	09093703          	ld	a4,144(s2)
    80200b42:	9f99                	subw	a5,a5,a4
    80200b44:	7cf4aa23          	sw	a5,2004(s1)

	for (int i = 0; i < 500; i++){
    80200b48:	09890793          	addi	a5,s2,152
    80200b4c:	00448713          	addi	a4,s1,4
    80200b50:	6605                	lui	a2,0x1
    80200b52:	03860613          	addi	a2,a2,56 # 1038 <_entry-0x801fefc8>
    80200b56:	964a                	add	a2,a2,s2
		ti->syscall_times[i] = p->syscall_times[i];
    80200b58:	6394                	ld	a3,0(a5)
    80200b5a:	c314                	sw	a3,0(a4)
	for (int i = 0; i < 500; i++){
    80200b5c:	07a1                	addi	a5,a5,8
    80200b5e:	0711                	addi	a4,a4,4
    80200b60:	fec79ce3          	bne	a5,a2,80200b58 <sys_task_info+0x48>
	}

	return 0;
}
    80200b64:	4501                	li	a0,0
    80200b66:	60e2                	ld	ra,24(sp)
    80200b68:	6442                	ld	s0,16(sp)
    80200b6a:	64a2                	ld	s1,8(sp)
    80200b6c:	6902                	ld	s2,0(sp)
    80200b6e:	6105                	addi	sp,sp,32
    80200b70:	8082                	ret

0000000080200b72 <syscall>:

extern char trap_page[];

void syscall()
{
    80200b72:	7139                	addi	sp,sp,-64
    80200b74:	fc06                	sd	ra,56(sp)
    80200b76:	f822                	sd	s0,48(sp)
    80200b78:	f426                	sd	s1,40(sp)
    80200b7a:	f04a                	sd	s2,32(sp)
    80200b7c:	ec4e                	sd	s3,24(sp)
    80200b7e:	e852                	sd	s4,16(sp)
    80200b80:	e456                	sd	s5,8(sp)
    80200b82:	0080                	addi	s0,sp,64
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200b84:	00000097          	auipc	ra,0x0
    80200b88:	a04080e7          	jalr	-1532(ra) # 80200588 <curr_proc>
    80200b8c:	01853903          	ld	s2,24(a0)
	int id = trapframe->a7, ret;
    80200b90:	0a892483          	lw	s1,168(s2)
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80200b94:	07093983          	ld	s3,112(s2)
    80200b98:	07893a03          	ld	s4,120(s2)
    80200b9c:	08093a83          	ld	s5,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    80200ba0:	09893883          	ld	a7,152(s2)
    80200ba4:	09093803          	ld	a6,144(s2)
    80200ba8:	08893783          	ld	a5,136(s2)
    80200bac:	8756                	mv	a4,s5
    80200bae:	86d2                	mv	a3,s4
    80200bb0:	864e                	mv	a2,s3
    80200bb2:	85a6                	mv	a1,s1
    80200bb4:	4501                	li	a0,0
    80200bb6:	00000097          	auipc	ra,0x0
    80200bba:	e6a080e7          	jalr	-406(ra) # 80200a20 <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	/*
	* LAB1: you may need to update syscall counter for task info here
	*/
	if(id>= 0 && id < 500){
    80200bbe:	1f300793          	li	a5,499
    80200bc2:	0297f863          	bgeu	a5,s1,80200bf2 <syscall+0x80>
		curr_proc()->syscall_times[id]++;
	}

	switch (id) {
    80200bc6:	07c00793          	li	a5,124
    80200bca:	0af48d63          	beq	s1,a5,80200c84 <syscall+0x112>
    80200bce:	0297dd63          	bge	a5,s1,80200c08 <syscall+0x96>
    80200bd2:	0a900793          	li	a5,169
    80200bd6:	0af48d63          	beq	s1,a5,80200c90 <syscall+0x11e>
    80200bda:	19a00793          	li	a5,410
    80200bde:	06f49863          	bne	s1,a5,80200c4e <syscall+0xdc>
		break;
	/*
	* LAB1: you may need to add SYS_taskinfo case here
	*/
	case SYS_task_info:
		ret = sys_task_info((struct TaskInfo *)args[0]);
    80200be2:	854e                	mv	a0,s3
    80200be4:	00000097          	auipc	ra,0x0
    80200be8:	f2c080e7          	jalr	-212(ra) # 80200b10 <sys_task_info>
    80200bec:	0005059b          	sext.w	a1,a0
		break;
    80200bf0:	a81d                	j	80200c26 <syscall+0xb4>
		curr_proc()->syscall_times[id]++;
    80200bf2:	00000097          	auipc	ra,0x0
    80200bf6:	996080e7          	jalr	-1642(ra) # 80200588 <curr_proc>
    80200bfa:	00349793          	slli	a5,s1,0x3
    80200bfe:	953e                	add	a0,a0,a5
    80200c00:	6d5c                	ld	a5,152(a0)
    80200c02:	0785                	addi	a5,a5,1
    80200c04:	ed5c                	sd	a5,152(a0)
    80200c06:	b7c1                	j	80200bc6 <syscall+0x54>
	switch (id) {
    80200c08:	04000793          	li	a5,64
    80200c0c:	02f49d63          	bne	s1,a5,80200c46 <syscall+0xd4>
		ret = sys_write(args[0], (char *)args[1], args[2]);
    80200c10:	000a861b          	sext.w	a2,s5
    80200c14:	85d2                	mv	a1,s4
    80200c16:	0009851b          	sext.w	a0,s3
    80200c1a:	00000097          	auipc	ra,0x0
    80200c1e:	e24080e7          	jalr	-476(ra) # 80200a3e <sys_write>
    80200c22:	0005059b          	sext.w	a1,a0
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
    80200c26:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    80200c2a:	4501                	li	a0,0
    80200c2c:	00000097          	auipc	ra,0x0
    80200c30:	df4080e7          	jalr	-524(ra) # 80200a20 <dummy>
}
    80200c34:	70e2                	ld	ra,56(sp)
    80200c36:	7442                	ld	s0,48(sp)
    80200c38:	74a2                	ld	s1,40(sp)
    80200c3a:	7902                	ld	s2,32(sp)
    80200c3c:	69e2                	ld	s3,24(sp)
    80200c3e:	6a42                	ld	s4,16(sp)
    80200c40:	6aa2                	ld	s5,8(sp)
    80200c42:	6121                	addi	sp,sp,64
    80200c44:	8082                	ret
	switch (id) {
    80200c46:	05d00793          	li	a5,93
    80200c4a:	02f48763          	beq	s1,a5,80200c78 <syscall+0x106>
		errorf("unknown syscall %d", id);
    80200c4e:	00000097          	auipc	ra,0x0
    80200c52:	924080e7          	jalr	-1756(ra) # 80200572 <threadid>
    80200c56:	86aa                	mv	a3,a0
    80200c58:	8726                	mv	a4,s1
    80200c5a:	00001617          	auipc	a2,0x1
    80200c5e:	4a660613          	addi	a2,a2,1190 # 80202100 <digits+0x50>
    80200c62:	45fd                	li	a1,31
    80200c64:	00001517          	auipc	a0,0x1
    80200c68:	4a450513          	addi	a0,a0,1188 # 80202108 <digits+0x58>
    80200c6c:	fffff097          	auipc	ra,0xfffff
    80200c70:	730080e7          	jalr	1840(ra) # 8020039c <printf>
		ret = -1;
    80200c74:	55fd                	li	a1,-1
    80200c76:	bf45                	j	80200c26 <syscall+0xb4>
	exit(code);
    80200c78:	0009851b          	sext.w	a0,s3
    80200c7c:	00000097          	auipc	ra,0x0
    80200c80:	b5a080e7          	jalr	-1190(ra) # 802007d6 <exit>
	yield();
    80200c84:	00000097          	auipc	ra,0x0
    80200c88:	b2e080e7          	jalr	-1234(ra) # 802007b2 <yield>
		ret = sys_sched_yield();
    80200c8c:	4581                	li	a1,0
		break;
    80200c8e:	bf61                	j	80200c26 <syscall+0xb4>
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
    80200c90:	000a059b          	sext.w	a1,s4
    80200c94:	854e                	mv	a0,s3
    80200c96:	00000097          	auipc	ra,0x0
    80200c9a:	e36080e7          	jalr	-458(ra) # 80200acc <sys_gettimeofday>
    80200c9e:	0005059b          	sext.w	a1,a0
		break;
    80200ca2:	b751                	j	80200c26 <syscall+0xb4>

0000000080200ca4 <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    80200ca4:	1141                	addi	sp,sp,-16
    80200ca6:	e422                	sd	s0,8(sp)
    80200ca8:	0800                	addi	s0,sp,16

// machine-mode cycle counter
static inline uint64 r_time()
{
	uint64 x;
	asm volatile("csrr %0, time" : "=r"(x));
    80200caa:	c0102573          	rdtime	a0
	return r_time();
}
    80200cae:	6422                	ld	s0,8(sp)
    80200cb0:	0141                	addi	sp,sp,16
    80200cb2:	8082                	ret

0000000080200cb4 <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    80200cb4:	1141                	addi	sp,sp,-16
    80200cb6:	e406                	sd	ra,8(sp)
    80200cb8:	e022                	sd	s0,0(sp)
    80200cba:	0800                	addi	s0,sp,16
    80200cbc:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80200cc0:	67fd                	lui	a5,0x1f
    80200cc2:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    80200cc6:	953e                	add	a0,a0,a5
    80200cc8:	00000097          	auipc	ra,0x0
    80200ccc:	b94080e7          	jalr	-1132(ra) # 8020085c <set_timer>
    80200cd0:	60a2                	ld	ra,8(sp)
    80200cd2:	6402                	ld	s0,0(sp)
    80200cd4:	0141                	addi	sp,sp,16
    80200cd6:	8082                	ret

0000000080200cd8 <timer_init>:
{
    80200cd8:	1141                	addi	sp,sp,-16
    80200cda:	e406                	sd	ra,8(sp)
    80200cdc:	e022                	sd	s0,0(sp)
    80200cde:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80200ce0:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    80200ce4:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80200ce8:	10479073          	csrw	sie,a5
	set_next_timer();
    80200cec:	00000097          	auipc	ra,0x0
    80200cf0:	fc8080e7          	jalr	-56(ra) # 80200cb4 <set_next_timer>
}
    80200cf4:	60a2                	ld	ra,8(sp)
    80200cf6:	6402                	ld	s0,0(sp)
    80200cf8:	0141                	addi	sp,sp,16
    80200cfa:	8082                	ret

0000000080200cfc <kerneltrap>:

extern char trampoline[], uservec[];
extern void *userret(uint64);

void kerneltrap()
{
    80200cfc:	1141                	addi	sp,sp,-16
    80200cfe:	e406                	sd	ra,8(sp)
    80200d00:	e022                	sd	s0,0(sp)
    80200d02:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200d04:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    80200d08:	1007f793          	andi	a5,a5,256
    80200d0c:	c3a1                	beqz	a5,80200d4c <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kernel\n");
    80200d0e:	00000097          	auipc	ra,0x0
    80200d12:	864080e7          	jalr	-1948(ra) # 80200572 <threadid>
    80200d16:	86aa                	mv	a3,a0
    80200d18:	47b9                	li	a5,14
    80200d1a:	00001717          	auipc	a4,0x1
    80200d1e:	41670713          	addi	a4,a4,1046 # 80202130 <digits+0x80>
    80200d22:	00001617          	auipc	a2,0x1
    80200d26:	2ee60613          	addi	a2,a2,750 # 80202010 <e_text+0x10>
    80200d2a:	45fd                	li	a1,31
    80200d2c:	00001517          	auipc	a0,0x1
    80200d30:	45450513          	addi	a0,a0,1108 # 80202180 <digits+0xd0>
    80200d34:	fffff097          	auipc	ra,0xfffff
    80200d38:	668080e7          	jalr	1640(ra) # 8020039c <printf>
    80200d3c:	00000097          	auipc	ra,0x0
    80200d40:	b08080e7          	jalr	-1272(ra) # 80200844 <shutdown>
}
    80200d44:	60a2                	ld	ra,8(sp)
    80200d46:	6402                	ld	s0,0(sp)
    80200d48:	0141                	addi	sp,sp,16
    80200d4a:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80200d4c:	00000097          	auipc	ra,0x0
    80200d50:	826080e7          	jalr	-2010(ra) # 80200572 <threadid>
    80200d54:	86aa                	mv	a3,a0
    80200d56:	47b5                	li	a5,13
    80200d58:	00001717          	auipc	a4,0x1
    80200d5c:	3d870713          	addi	a4,a4,984 # 80202130 <digits+0x80>
    80200d60:	00001617          	auipc	a2,0x1
    80200d64:	2b060613          	addi	a2,a2,688 # 80202010 <e_text+0x10>
    80200d68:	45fd                	li	a1,31
    80200d6a:	00001517          	auipc	a0,0x1
    80200d6e:	3d650513          	addi	a0,a0,982 # 80202140 <digits+0x90>
    80200d72:	fffff097          	auipc	ra,0xfffff
    80200d76:	62a080e7          	jalr	1578(ra) # 8020039c <printf>
    80200d7a:	00000097          	auipc	ra,0x0
    80200d7e:	aca080e7          	jalr	-1334(ra) # 80200844 <shutdown>
    80200d82:	b771                	j	80200d0e <kerneltrap+0x12>

0000000080200d84 <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void set_usertrap(void)
{
    80200d84:	1141                	addi	sp,sp,-16
    80200d86:	e422                	sd	s0,8(sp)
    80200d88:	0800                	addi	s0,sp,16
	w_stvec((uint64)uservec & ~0x3); // DIRECT
    80200d8a:	00000797          	auipc	a5,0x0
    80200d8e:	29678793          	addi	a5,a5,662 # 80201020 <trampoline>
    80200d92:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200d94:	10579073          	csrw	stvec,a5
}
    80200d98:	6422                	ld	s0,8(sp)
    80200d9a:	0141                	addi	sp,sp,16
    80200d9c:	8082                	ret

0000000080200d9e <set_kerneltrap>:

void set_kerneltrap(void)
{
    80200d9e:	1141                	addi	sp,sp,-16
    80200da0:	e422                	sd	s0,8(sp)
    80200da2:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80200da4:	00000797          	auipc	a5,0x0
    80200da8:	f5878793          	addi	a5,a5,-168 # 80200cfc <kerneltrap>
    80200dac:	9bf1                	andi	a5,a5,-4
    80200dae:	10579073          	csrw	stvec,a5
}
    80200db2:	6422                	ld	s0,8(sp)
    80200db4:	0141                	addi	sp,sp,16
    80200db6:	8082                	ret

0000000080200db8 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init(void)
{
    80200db8:	1141                	addi	sp,sp,-16
    80200dba:	e422                	sd	s0,8(sp)
    80200dbc:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80200dbe:	00000797          	auipc	a5,0x0
    80200dc2:	f3e78793          	addi	a5,a5,-194 # 80200cfc <kerneltrap>
    80200dc6:	9bf1                	andi	a5,a5,-4
    80200dc8:	10579073          	csrw	stvec,a5
	set_kerneltrap();
}
    80200dcc:	6422                	ld	s0,8(sp)
    80200dce:	0141                	addi	sp,sp,16
    80200dd0:	8082                	ret

0000000080200dd2 <unknown_trap>:

void unknown_trap()
{
    80200dd2:	1141                	addi	sp,sp,-16
    80200dd4:	e406                	sd	ra,8(sp)
    80200dd6:	e022                	sd	s0,0(sp)
    80200dd8:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p\n", r_scause(), r_stval());
    80200dda:	fffff097          	auipc	ra,0xfffff
    80200dde:	798080e7          	jalr	1944(ra) # 80200572 <threadid>
    80200de2:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80200de4:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80200de8:	143027f3          	csrr	a5,stval
    80200dec:	00001617          	auipc	a2,0x1
    80200df0:	31460613          	addi	a2,a2,788 # 80202100 <digits+0x50>
    80200df4:	45fd                	li	a1,31
    80200df6:	00001517          	auipc	a0,0x1
    80200dfa:	3ba50513          	addi	a0,a0,954 # 802021b0 <digits+0x100>
    80200dfe:	fffff097          	auipc	ra,0xfffff
    80200e02:	59e080e7          	jalr	1438(ra) # 8020039c <printf>
	exit(-1);
    80200e06:	557d                	li	a0,-1
    80200e08:	00000097          	auipc	ra,0x0
    80200e0c:	9ce080e7          	jalr	-1586(ra) # 802007d6 <exit>
}
    80200e10:	60a2                	ld	ra,8(sp)
    80200e12:	6402                	ld	s0,0(sp)
    80200e14:	0141                	addi	sp,sp,16
    80200e16:	8082                	ret

0000000080200e18 <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    80200e18:	1101                	addi	sp,sp,-32
    80200e1a:	ec06                	sd	ra,24(sp)
    80200e1c:	e822                	sd	s0,16(sp)
    80200e1e:	e426                	sd	s1,8(sp)
    80200e20:	1000                	addi	s0,sp,32
	w_stvec((uint64)uservec & ~0x3); // DIRECT
    80200e22:	00000797          	auipc	a5,0x0
    80200e26:	1fe78793          	addi	a5,a5,510 # 80201020 <trampoline>
    80200e2a:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200e2c:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200e30:	fffff097          	auipc	ra,0xfffff
    80200e34:	758080e7          	jalr	1880(ra) # 80200588 <curr_proc>
    80200e38:	6d04                	ld	s1,24(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    80200e3a:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80200e3e:	e09c                	sd	a5,0(s1)
	trapframe->kernel_sp =
		curr_proc()->kstack + PGSIZE; // process's kernel stack
    80200e40:	fffff097          	auipc	ra,0xfffff
    80200e44:	748080e7          	jalr	1864(ra) # 80200588 <curr_proc>
    80200e48:	691c                	ld	a5,16(a0)
    80200e4a:	6705                	lui	a4,0x1
    80200e4c:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80200e4e:	e49c                	sd	a5,8(s1)
	trapframe->kernel_trap = (uint64)usertrap;
    80200e50:	00000797          	auipc	a5,0x0
    80200e54:	03878793          	addi	a5,a5,56 # 80200e88 <usertrap>
    80200e58:	e89c                	sd	a5,16(s1)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80200e5a:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80200e5c:	f09c                	sd	a5,32(s1)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80200e5e:	6c9c                	ld	a5,24(s1)
    80200e60:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200e64:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80200e68:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80200e6c:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200e70:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	// uint64 satp = MAKE_SATP(p->pagetable);
	userret((uint64)trapframe);
    80200e74:	8526                	mv	a0,s1
    80200e76:	00000097          	auipc	ra,0x0
    80200e7a:	23a080e7          	jalr	570(ra) # 802010b0 <userret>
    80200e7e:	60e2                	ld	ra,24(sp)
    80200e80:	6442                	ld	s0,16(sp)
    80200e82:	64a2                	ld	s1,8(sp)
    80200e84:	6105                	addi	sp,sp,32
    80200e86:	8082                	ret

0000000080200e88 <usertrap>:
{
    80200e88:	1101                	addi	sp,sp,-32
    80200e8a:	ec06                	sd	ra,24(sp)
    80200e8c:	e822                	sd	s0,16(sp)
    80200e8e:	e426                	sd	s1,8(sp)
    80200e90:	1000                	addi	s0,sp,32
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80200e92:	00000797          	auipc	a5,0x0
    80200e96:	e6a78793          	addi	a5,a5,-406 # 80200cfc <kerneltrap>
    80200e9a:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200e9c:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200ea0:	fffff097          	auipc	ra,0xfffff
    80200ea4:	6e8080e7          	jalr	1768(ra) # 80200588 <curr_proc>
    80200ea8:	6d04                	ld	s1,24(a0)
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200eaa:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80200eae:	1007f793          	andi	a5,a5,256
    80200eb2:	e395                	bnez	a5,80200ed6 <usertrap+0x4e>
	asm volatile("csrr %0, scause" : "=r"(x));
    80200eb4:	142025f3          	csrr	a1,scause
	if (cause & (1ULL << 63)) {
    80200eb8:	0405cc63          	bltz	a1,80200f10 <usertrap+0x88>
		switch (cause) {
    80200ebc:	47bd                	li	a5,15
    80200ebe:	0eb7e063          	bltu	a5,a1,80200f9e <usertrap+0x116>
    80200ec2:	00259713          	slli	a4,a1,0x2
    80200ec6:	00001697          	auipc	a3,0x1
    80200eca:	3ce68693          	addi	a3,a3,974 # 80202294 <digits+0x1e4>
    80200ece:	9736                	add	a4,a4,a3
    80200ed0:	431c                	lw	a5,0(a4)
    80200ed2:	97b6                	add	a5,a5,a3
    80200ed4:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80200ed6:	fffff097          	auipc	ra,0xfffff
    80200eda:	69c080e7          	jalr	1692(ra) # 80200572 <threadid>
    80200ede:	86aa                	mv	a3,a0
    80200ee0:	03200793          	li	a5,50
    80200ee4:	00001717          	auipc	a4,0x1
    80200ee8:	24c70713          	addi	a4,a4,588 # 80202130 <digits+0x80>
    80200eec:	00001617          	auipc	a2,0x1
    80200ef0:	12460613          	addi	a2,a2,292 # 80202010 <e_text+0x10>
    80200ef4:	45fd                	li	a1,31
    80200ef6:	00001517          	auipc	a0,0x1
    80200efa:	2ea50513          	addi	a0,a0,746 # 802021e0 <digits+0x130>
    80200efe:	fffff097          	auipc	ra,0xfffff
    80200f02:	49e080e7          	jalr	1182(ra) # 8020039c <printf>
    80200f06:	00000097          	auipc	ra,0x0
    80200f0a:	93e080e7          	jalr	-1730(ra) # 80200844 <shutdown>
    80200f0e:	b75d                	j	80200eb4 <usertrap+0x2c>
		cause &= ~(1ULL << 63);
    80200f10:	0586                	slli	a1,a1,0x1
    80200f12:	8185                	srli	a1,a1,0x1
		switch (cause) {
    80200f14:	4795                	li	a5,5
    80200f16:	00f58f63          	beq	a1,a5,80200f34 <usertrap+0xac>
			unknown_trap();
    80200f1a:	00000097          	auipc	ra,0x0
    80200f1e:	eb8080e7          	jalr	-328(ra) # 80200dd2 <unknown_trap>
	usertrapret();
    80200f22:	00000097          	auipc	ra,0x0
    80200f26:	ef6080e7          	jalr	-266(ra) # 80200e18 <usertrapret>
}
    80200f2a:	60e2                	ld	ra,24(sp)
    80200f2c:	6442                	ld	s0,16(sp)
    80200f2e:	64a2                	ld	s1,8(sp)
    80200f30:	6105                	addi	sp,sp,32
    80200f32:	8082                	ret
			tracef("time interrupt!\n");
    80200f34:	4501                	li	a0,0
    80200f36:	00000097          	auipc	ra,0x0
    80200f3a:	aea080e7          	jalr	-1302(ra) # 80200a20 <dummy>
			set_next_timer();
    80200f3e:	00000097          	auipc	ra,0x0
    80200f42:	d76080e7          	jalr	-650(ra) # 80200cb4 <set_next_timer>
			yield();
    80200f46:	00000097          	auipc	ra,0x0
    80200f4a:	86c080e7          	jalr	-1940(ra) # 802007b2 <yield>
			break;
    80200f4e:	bfd1                	j	80200f22 <usertrap+0x9a>
			trapframe->epc += 4;
    80200f50:	6c9c                	ld	a5,24(s1)
    80200f52:	0791                	addi	a5,a5,4
    80200f54:	ec9c                	sd	a5,24(s1)
			syscall();
    80200f56:	00000097          	auipc	ra,0x0
    80200f5a:	c1c080e7          	jalr	-996(ra) # 80200b72 <syscall>
			break;
    80200f5e:	b7d1                	j	80200f22 <usertrap+0x9a>
	asm volatile("csrr %0, stval" : "=r"(x));
    80200f60:	14302673          	csrr	a2,stval
			printf("%d in application, bad addr = %p, bad instruction = %p, "
    80200f64:	6c94                	ld	a3,24(s1)
    80200f66:	00001517          	auipc	a0,0x1
    80200f6a:	2b250513          	addi	a0,a0,690 # 80202218 <digits+0x168>
    80200f6e:	fffff097          	auipc	ra,0xfffff
    80200f72:	42e080e7          	jalr	1070(ra) # 8020039c <printf>
			exit(-2);
    80200f76:	5579                	li	a0,-2
    80200f78:	00000097          	auipc	ra,0x0
    80200f7c:	85e080e7          	jalr	-1954(ra) # 802007d6 <exit>
			break;
    80200f80:	b74d                	j	80200f22 <usertrap+0x9a>
			printf("IllegalInstruction in application, core dumped.\n");
    80200f82:	00001517          	auipc	a0,0x1
    80200f86:	2de50513          	addi	a0,a0,734 # 80202260 <digits+0x1b0>
    80200f8a:	fffff097          	auipc	ra,0xfffff
    80200f8e:	412080e7          	jalr	1042(ra) # 8020039c <printf>
			exit(-3);
    80200f92:	5575                	li	a0,-3
    80200f94:	00000097          	auipc	ra,0x0
    80200f98:	842080e7          	jalr	-1982(ra) # 802007d6 <exit>
			break;
    80200f9c:	b759                	j	80200f22 <usertrap+0x9a>
			unknown_trap();
    80200f9e:	00000097          	auipc	ra,0x0
    80200fa2:	e34080e7          	jalr	-460(ra) # 80200dd2 <unknown_trap>
			break;
    80200fa6:	bfb5                	j	80200f22 <usertrap+0x9a>

0000000080200fa8 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    80200fa8:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80200fac:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80200fb0:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80200fb2:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80200fb4:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80200fb8:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80200fbc:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80200fc0:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80200fc4:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80200fc8:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80200fcc:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80200fd0:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80200fd4:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80200fd8:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80200fdc:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80200fe0:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80200fe4:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80200fe6:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80200fe8:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80200fec:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80200ff0:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80200ff4:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80200ff8:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80200ffc:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80201000:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80201004:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80201008:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8020100c:	0685bd83          	ld	s11,104(a1)

    80201010:	8082                	ret
	...

0000000080201020 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80201020:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80201024:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80201028:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020102c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80201030:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80201034:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80201038:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020103c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80201040:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80201042:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80201044:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80201046:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80201048:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020104a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020104c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020104e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80201052:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80201056:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020105a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020105e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80201062:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80201066:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020106a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020106e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80201072:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80201076:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020107a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020107e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80201082:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80201086:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020108a:	11f53c23          	sd	t6,280(a0)

	    # save the user a0 in p->trapframe->a0
        csrr t0, sscratch
    8020108e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80201092:	06553823          	sd	t0,112(a0)

        csrr t1, sepc
    80201096:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020109a:	00653c23          	sd	t1,24(a0)

        ld sp, 8(a0)
    8020109e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    802010a2:	02053203          	ld	tp,32(a0)
        ld t1, 0(a0)
    802010a6:	00053303          	ld	t1,0(a0)
        # csrw satp, t1
        # sfence.vma zero, zero
        ld t0, 16(a0)
    802010aa:	01053283          	ld	t0,16(a0)
        jr t0
    802010ae:	8282                	jr	t0

00000000802010b0 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    802010b0:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    802010b4:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802010b8:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802010bc:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802010c0:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802010c4:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802010c8:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802010cc:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802010d0:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802010d4:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802010d8:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802010dc:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802010de:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802010e0:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802010e2:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802010e4:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802010e6:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802010e8:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802010ea:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802010ee:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802010f2:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802010f6:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802010fa:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802010fe:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    80201102:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    80201106:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    8020110a:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    8020110e:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    80201112:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    80201116:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    8020111a:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    8020111e:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    80201122:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    80201126:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    8020112a:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    8020112e:	10200073          	sret
	...
